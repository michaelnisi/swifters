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

final class DetailDataSource: DataSource {

  func update(
    using item: DataSourceItem,
    completionBlock: (([[DataSourceItem]]) -> Void)? = nil
  ) {
    switch item {
    case .message, .contact, .detail:
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

          let msg = DataSource.makeMessage(error: er)

          completionBlock?([[.message(msg)]])
          return
        }

        guard let userDetail = result?.data?.node?.fragments.userDetail else {
          os_log("unexpected result", log: log)
          completionBlock?([[.message("Unexpected Result")]])
          return
        }

        // Kind of unfortunate that the email field isn’t Optional.
        guard userDetail.email != "" else {
          completionBlock?([[.detail(userDetail, user.createdAt)]])
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
