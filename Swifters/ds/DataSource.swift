//
//  DataSource.swift
//  Swifters
//
//  Created by Michael Nisi on 07.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit
import Apollo
import Ola
import os.log

// Enumerates all item types provided by data sources in this app.
enum DataSourceItem {

  /// A search result user and its cursor.
  case user(SearchResultUser, String)

  /// User details are fetched extra.
  case detail(UserDetail, String)

  /// A simple message string to display.
  case message(String)

  /// User details.
  case contact(UserDetail)

}

extension DataSourceItem: Hashable {
  public var hashValue: Int {
    switch self {
    case .message(let string):
      return string.hashValue
    case .user(let user, _):
      // 🤔
      return user.id.hashValue
    case .contact(let userDetail):
      return userDetail.id.hashValue
    case .detail(let userDetail, _):
      return userDetail.id.hashValue
    }
  }
}

extension DataSourceItem: Equatable {

  static func == (lhs: DataSourceItem, rhs: DataSourceItem) -> Bool {
    switch (lhs, rhs) {
    case (.user(let a, _), .user(let b, _)):
      return a.id == b.id
    case (.contact(let a), .contact(let b)):
      return a.id == b.id
    case (.detail(let a, _), .detail(let b, _)):
      return a.id == b.id
    case (.message(let a), .message(let b)):
      return a == b
    case (.message, _), (.user, _), (.contact, _), (.detail, _):
      return false
    }
  }

}

/// A super class for collection view data sources.
class DataSource: NSObject {

  static var messageCollectionViewCellID = "MessageCollectionViewCellID"
  static var userCollectionViewCellID = "UserCollectionViewCellID"
  static var contactCollectionViewCellID = "ContactCollectionViewCellID"
  static var detailUserCollectionViewCellID = "DetailUserCollectionViewCellID"

  var sections: [[DataSourceItem]]

  init(sections: [[DataSourceItem]] = [[.message("Welcome")]]) {
    self.sections = sections
  }

  /// Creates a new data source, prepopulated with `message`.
  init(message string: String) {
    self.sections = [[.message(string)]]
  }

  private var probe: Ola? {
    willSet {
      probe?.invalidate()
    }
  }

  /// Invalidates and releases the probe.
  func invalidateProbe() {
    probe = nil
  }

  var isInvalid = false

  /// Invalidates this data source. Using an invalid data source is an error.
  @discardableResult
  func invalidate() -> [[DataSourceItem]]  {
    invalidateProbe()
    isInvalid = true
    return [[.message("Invalid Data Source.")]]
  }

  var sendEmailBlock: ((URL) -> Void)?

}

// MARK: - Checking Reachability

extension DataSource {

  func checkReachability(log: OSLog, retryBlock: @escaping () -> Void) {
    DispatchQueue.global().async {
      if let probe = Ola(host: "1.1.1.1", log: log) {
        guard probe.reach() != .reachable else {
          return
        }

        probe.activate { status in
          defer {
            probe.invalidate()
          }

          guard status == .reachable else {
            return
          }

          retryBlock()
        }

        self.probe = probe
      }
    }
  }

}

// MARK: - Date Formatting

extension DataSource {

  private static var apolloDateFormatter: DateFormatter = {
    let df = DateFormatter()

    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

    return df
  }()

  private static var naturalDateFormatter: DateFormatter = {
    let df = DateFormatter()

    df.timeStyle = .none
    df.dateStyle = .medium
    df.locale = Locale(identifier: "en_US")

    return df
  }()

  private static func makeDateCreatedAtString(string: String) -> String {
    let df = DataSource.apolloDateFormatter

    guard let date = df.date(from: string),
      let str = naturalDateFormatter.string(for: date) else {
        return ""
    }

    return str
  }

}

// MARK: - Helpers

extension DataSource {

  static func makeMessage(error: Error) -> String {
    struct ErrorDescription: Codable {
      let message: String
      let documentation_url: String
    }

    if let er = error as? Apollo.GraphQLHTTPResponseError {
      let data = er.body!
      let decoder = JSONDecoder()
      do {
        return try decoder.decode(ErrorDescription.self, from: data).message
      } catch {
        return error.localizedDescription
      }
    }

    return error.localizedDescription
  }

  /// Registers all cell nib files for `collectionView`.
  static func registerCellClasses(_ collectionView: UICollectionView) {
    collectionView.register(
      UINib(nibName: "UserCollectionViewCell", bundle: .main),
      forCellWithReuseIdentifier: DataSource.userCollectionViewCellID
    )

    collectionView.register(
      UINib(nibName: "ContactCollectionViewCell", bundle: .main),
      forCellWithReuseIdentifier: DataSource.contactCollectionViewCellID
    )

    collectionView.register(
      UINib(nibName: "MessageCollectionViewCell", bundle: .main),
      forCellWithReuseIdentifier: DataSource.messageCollectionViewCellID
    )

    collectionView.register(
      UINib(nibName: "DetailUserCollectionViewCell", bundle: .main),
      forCellWithReuseIdentifier: DataSource.detailUserCollectionViewCellID
    )
  }

}

// MARK: - Accessing Items

extension DataSource {

  func dataSourceItem(matching indexPath: IndexPath) -> DataSourceItem {
    return sections[indexPath.section][indexPath.row]
  }
  
}

// MARK: - Accessing Items

extension DataSource: UICollectionViewDataSource {

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
    let item = dataSourceItem(matching: indexPath)

    switch item {
    case .user(let user, _):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DataSource.userCollectionViewCellID,
        for: indexPath) as! UserCollectionViewCell

      cell.layer.cornerRadius = 16
      cell.layer.masksToBounds = true

      cell.titleLabel.text = user.name

      // Only interested in the year, we are taking a shortcut.
      cell.captionLabel.text = String(user.createdAt.prefix(4))

      Images.shared.cancel(displaying: cell.avatarImageView)
      cell.avatarImageView.image = nil
      Images.shared.load(imageUrl: user.avatarUrl, view: cell.avatarImageView)

      return cell

    case .detail(let userDetail, let createdAt):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DataSource.detailUserCollectionViewCellID,
        for: indexPath) as! DetailUserCollectionViewCell

      cell.layer.cornerRadius = 0
      cell.layer.masksToBounds = true

      Images.shared.cancel(displaying: cell.heroImageView)
      cell.heroImageView.image = nil
      Images.shared.load(imageUrl: userDetail.avatarUrl, view: cell.heroImageView)

      cell.titleLabel.text = "\(userDetail.followers.totalCount) Followers"
      let date = DataSource.makeDateCreatedAtString(string: createdAt)
      cell.subtitleLabel.text = "Since \(date)"

      if let gitHubURL = URL(string: userDetail.url) {
        cell.sleeveBlock = {
          UIApplication.shared.open(gitHubURL)
        }
      }

      return cell

    case .contact(let userDetail):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DataSource.contactCollectionViewCellID,
        for: indexPath) as! ContactCollectionViewCell

      cell.layer.cornerRadius = 0
      cell.layer.masksToBounds = false

      cell.bodyLabel.text = userDetail.bio

      guard userDetail.email != "",
        let emailURL = URL(string: "mailto:\(userDetail.email)") else {
        cell.mailButton.setTitle("", for: .normal)
        return cell
      }

      cell.mailButton.setTitle(userDetail.email, for: .normal)
      cell.mailButtonBlock = {
        UIApplication.shared.open(emailURL)
      }

      return cell

    case .message(let string):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DataSource.messageCollectionViewCellID,
        for: indexPath) as! MessageCollectionViewCell

      cell.titleLabel.text = string

      return cell
    }
  }

}
