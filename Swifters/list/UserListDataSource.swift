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

final class UserListDataSource: DataSource {

  /// The current fetching state.
  private var state = FetchingState()

}

// MARK: Prefetching Items

extension UserListDataSource {

  /// Returns `true` if `indexPath` represents the last item.
  func isLastItem(indexPath: IndexPath) -> Bool {
    precondition(!isInvalid)
    
    guard let last = sections.first?.last else {
      return false
    }

    return dataSourceItem(matching: indexPath) == last
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
      case .user(_, let cursor) = dataSourceItem(matching:
        indexPathsToPreload.first!) else {
      return nil
    }

    return cursor
  }

  func searchUsers(
    indexPaths: [IndexPath]? = nil,
    completionBlock: (([[DataSourceItem]]) -> Void)? = nil
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
        queryString: "language:Swift",
        cursor: cursor
      )
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

        let msg = DataSource.makeMessage(error: er)

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

        let user: DataSourceItem = .user(searchResultUser, e.cursor)
        
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
