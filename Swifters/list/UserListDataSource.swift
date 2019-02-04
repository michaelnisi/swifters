//
//  UserDataSource.swift
//  Swifters
//
//  Created by Michael Nisi on 04.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit
import os.log
import Apollo

private let log = OSLog(subsystem: "ink.codes.swifters", category: "list")

/// Represents a state of fetching.
private struct FetchingState {

  let cursor: String?
  weak var ref: Apollo.Cancellable?
  let ts: TimeInterval

  /// Passing no Apollo object sets the timestamp to zero.
  init(cursor: String? = nil, ref: Apollo.Cancellable? = nil) {
    self.cursor = cursor
    self.ref = ref
    self.ts = ref != nil ? Date().timeIntervalSince1970 : TimeInterval(0)
  }

  /// Returns `true` if fetching users may be advisable.
  func isAllowing(cursor: String?) -> Bool {
    guard ref == nil else {
      os_log("still fetching", log: log, type: .debug)

      if Date().timeIntervalSince1970 - ts > 60 {
        os_log("** apollo has problems", log: log)
      }

      return false
    }

    if cursor != nil, cursor == self.cursor {
      os_log("repeating cursor detected", log: log)
      // Tolerating repeating cursors after some time has passed.
      return Date().timeIntervalSince1970 - ts > 60
    }

    return true
  }

}

final class UserListDataSource: Reachability {

  static var messageCollectionViewCellID = "MessageCollectionViewCellID"
  static var userCollectionViewCellID = "UserCollectionViewCellID"

  /// Registers all cell nib files for `collectionView`.
  static func registerCellClasses(_ collectionView: UICollectionView) {
    let cells = [
      ("UserCollectionViewCell", userCollectionViewCellID),
      ("MessageCollectionViewCell", messageCollectionViewCellID)
    ]

    for cell in cells {
      collectionView.register(
        UINib(nibName: cell.0, bundle: .main),
        forCellWithReuseIdentifier: cell.1
      )
    }
  }

  /// Enumerates item types provided by this data source.
  enum Item: Hashable {

    /// A search result user and its cursor.
    case user(SearchResultUser, String)
    
    /// A simple message string to display.
    case message(String)

    static func == (lhs: Item, rhs: Item) -> Bool {
      switch (lhs, rhs) {
      case (.user(let a, _), .user(let b, _)):
        return a.id == b.id
      case (.message(let a), .message(let b)):
        return a == b
      case (.message, _), (.user, _):
        return false
      }
    }

    public var hashValue: Int {
      switch self {
      case .message(let string):
        return string.hashValue
      case .user(let user, _):
        return user.id.hashValue
      }
    }

  }

  var sections: [[Item]]

  init(sections: [[Item]] = [[.message("We ♥ Swift")]]) {
    self.sections = sections
  }

  /// Creates a new data source, prepopulated with `message`.
  init(message string: String) {
    self.sections = [[.message(string)]]
  }

  /// The current fetching state.
  private var state = FetchingState()

  /// The query string, defaults to `"language:Swift"`.
  var queryString = "language:Swift"

  /// The number of items to fetch, defaults to 10.
  var first: Int = 10

}

// MARK: - SwiftersDataSource

extension UserListDataSource: SectionedItems {}

// MARK: - UICollectionViewDataSource

extension UserListDataSource: UICollectionViewDataSource {

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
    case .user(let user, _):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: UserListDataSource.userCollectionViewCellID,
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

    case .message(let string):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: UserListDataSource.messageCollectionViewCellID,
        for: indexPath) as! MessageCollectionViewCell

      cell.titleLabel.text = string

      return cell
    }
  }

}

// MARK: - Prefetching Items

extension UserListDataSource {

  /// Returns `true` if `indexPath` represents the last item.
  func isLastItem(indexPath: IndexPath) -> Bool {
    precondition(!isInvalid)
    
    guard let last = sections.first?.last else {
      return false
    }

    return itemAt(indexPath: indexPath) == last
  }

  /// Is `true` if this data source can be assumed to be empty.
  var isEmpty: Bool {
    guard let first = sections.first?.first, case .user = first else {
      return true
    }

    return false
  }

}

// MARK: - Querying GitHub

extension UserListDataSource {

  /// Returns `true` if we are currently displaying a message.
  private var isShowingMessage: Bool {
    guard let item = sections.first?.first, case .message = item else {
      return false
    }

    return true
  }

  private func makeCursor(indexPaths: [IndexPath]? = nil) -> String? {
    guard let indexPathsToPreload = indexPaths else {
      return nil
    }

    let shouldNotFetch = indexPathsToPreload.filter {
      return isLastItem(indexPath: $0)
      }.isEmpty

    guard !shouldNotFetch,
      case .user(_, let cursor)? = itemAt(indexPath:
        indexPathsToPreload.first!) else {
      return nil
    }

    return cursor
  }

  func searchUsers(
    indexPaths: [IndexPath]? = nil,
    completionBlock: (([[Item]]) -> Void)? = nil
  ) {
    precondition(!isInvalid)

    let cursor = makeCursor(indexPaths: indexPaths)

    if indexPaths != nil {
      guard cursor != nil else {
        return
      }
    }

    // Releasing a possible probe that may be waiting for a callback.
    invalidateProbe()

    guard state.isAllowing(cursor: cursor) else {
      return os_log("not searching users", log: log, type: .debug)
    }

    var users = sections.first?.filter {
      guard case .user = $0 else {
        return false
      }

      return true
    } ?? []

    os_log("searching users", log: log, type: .debug)

    let ref = GitHub.shared.fetch(
      query: UserSearchQuery(
        queryString: queryString, first: first, cursor: cursor)
    ) { (result, error) in
      os_log("received result or error", log: log, type: .debug)

      guard error == nil else {
        let er = error!
        os_log("user search query failed: %{public}@",
               log: log, er as CVarArg)

        // Not interrupting endless scrolling.

        guard cursor == nil else {
          completionBlock?(self.sections)
          return
        }

        self.checkReachability(log: log) { [weak self] in
          DispatchQueue.main.async {
            // Resetting, we may be under the threshold.
            self?.state = FetchingState()

            self?.searchUsers { sections in
              completionBlock?(sections)
            }
          }
        }

        let msg = GitHub.makeMessage(error: er)

        completionBlock?([[.message(msg)]])
        return
      }

      guard let edges = result?.data?.search.edges else {
        os_log("unexpected result", log: log)
        completionBlock?([[.message("Unexpected Result")]])
        return
      }

      for edge in edges {
        guard let e = edge,
          let searchResultUser = e.node?.fragments.searchResultUser else {
          continue
        }

        let user: Item = .user(searchResultUser, e.cursor)
        
        guard !users.contains(user) else {
          continue
        }

        users.append(user)
      }

      completionBlock?([users])
    }

    state = FetchingState(cursor: cursor, ref: ref)
  }

}
