//
//  DetailDataSource.swift
//  Swifters
//
//  Created by Michael Nisi on 04.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit
import os.log
import Ola

private let log = OSLog(subsystem: "ink.codes.swifters", category: "detail")

final class DetailDataSource: Reachability {

  static var messageCollectionViewCellID = "MessageCollectionViewCellID"
  static var contactCollectionViewCellID = "ContactCollectionViewCellID"
  static var detailUserCollectionViewCellID = "DetailUserCollectionViewCellID"

  /// Registers all cell nib files for `collectionView`.
  static func registerCellClasses(_ collectionView: UICollectionView) {
    let cells = [
      ("ContactCollectionViewCell", contactCollectionViewCellID),
      ("MessageCollectionViewCell", messageCollectionViewCellID),
      ("DetailUserCollectionViewCell", detailUserCollectionViewCellID)
    ]

    for cell in cells {
      collectionView.register(
        UINib(nibName: cell.0, bundle: .main),
        forCellWithReuseIdentifier: cell.1
      )
    }
  }

  enum Item: Hashable {

    /// A simple message string to display.
    case message(String)

    /// User details.
    case contact(UserDetail)

    /// User details are fetched extra.
    case detail(UserDetail, String)

    static func == (lhs: Item, rhs: Item) -> Bool {
      switch (lhs, rhs) {
      case (.contact(let a), .contact(let b)):
        return a.id == b.id
      case (.detail(let a, _), .detail(let b, _)):
        return a.id == b.id
      case (.message(let a), .message(let b)):
        return a == b
      case (.message, _), (.contact, _), (.detail, _):
        return false
      }
    }

    public var hashValue: Int {
      switch self {
      case .message(let string):
        return string.hashValue
      case .contact(let userDetail):
        return userDetail.id.hashValue
      case .detail(let userDetail, _):
        return userDetail.id.hashValue
      }
    }

  }

  var sections: [[Item]]

  init(sections: [[Item]] = [[.message("Loading…")]]) {
    self.sections = sections
  }

  /// Creates a new data source, prepopulated with `message`.
  init(message string: String) {
    self.sections = [[.message(string)]]
  }

  /// A block for sending email.
  var sendEmailBlock: ((URL) -> Void)?

}

// MARK: - SwiftersDataSource

extension DetailDataSource: SectionedItems {}

// MARK: - UICollectionViewDataSource

extension DetailDataSource: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return sections[section].count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
    let item = itemAt(indexPath: indexPath)!

    switch item {
    case .detail(let userDetail, let createdAt):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DetailDataSource.detailUserCollectionViewCellID,
        for: indexPath) as! DetailUserCollectionViewCell

      cell.layer.cornerRadius = 0
      cell.layer.masksToBounds = true

      Images.shared.cancel(displaying: cell.heroImageView)
      cell.heroImageView.image = nil
      Images.shared.load(imageUrl: userDetail.avatarUrl, view: cell.heroImageView)

      cell.titleLabel.text = "\(userDetail.followers.totalCount) Followers"

      let date = GitHub.makeDateCreatedAtString(string: createdAt)
      
      cell.subtitleLabel.text = "Since \(date)"

      if let gitHubURL = URL(string: userDetail.url) {
        cell.sleeveBlock = {
          UIApplication.shared.open(gitHubURL)
        }
      }

      return cell

    case .contact(let userDetail):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DetailDataSource.contactCollectionViewCellID,
        for: indexPath) as! ContactCollectionViewCell

      cell.layer.cornerRadius = 0
      cell.layer.masksToBounds = false

      cell.bodyLabel.text = userDetail.bio

      guard userDetail.email != "",
        let emailURL = URL(string: "mailto:\(userDetail.email)") else {
        cell.mailButton.isHidden = true

        cell.mailButton.setTitle("", for: .normal)

        return cell
      }

      cell.mailButton.isHidden = false

      cell.mailButton.setTitle(userDetail.email, for: .normal)
      cell.mailButtonBlock = {
        UIApplication.shared.open(emailURL)
      }

      return cell

    case .message(let string):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DetailDataSource.messageCollectionViewCellID,
        for: indexPath) as! MessageCollectionViewCell

      cell.titleLabel.text = string

      return cell
    }
  }

}

// MARK: - Updating

extension DetailDataSource {

  func update(
    using item: UserListDataSource.Item,
    completionBlock: (([[Item]]) -> Void)? = nil
  ) {
    switch item {
    case .message:
      break

    case .user(let user, _):
      os_log("fetching user node", log: log, type: .debug)

      // Releasing a possible probe that may be waiting for a callback.
      invalidateProbe()

      GitHub.shared.fetch(query: UserNodeQuery(id: user.id)) { result, error in
        os_log("received result or error", log: log, type: .debug)

        guard error == nil else {
          let er = error!
          os_log("user node query failed: %{public}@", log: log, er as CVarArg)

          self.checkReachability(log: log) { [weak self] in
            DispatchQueue.main.async {
              self?.update(using: item) { sections in
                completionBlock?(sections)
              }
            }
          }

          let msg = GitHub.makeMessage(error: er)

          completionBlock?([[.message(msg)]])
          return
        }

        guard let userDetail = result?.data?.node?.fragments.userDetail else {
          os_log("unexpected result", log: log)
          completionBlock?([[.message("Unexpected Result")]])
          return
        }

        completionBlock?([[
          .detail(userDetail, user.createdAt),
          .contact(userDetail)]]
        )
      }
    }
  }

}
