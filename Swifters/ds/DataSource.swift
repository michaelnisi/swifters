//
//  DataSource.swift
//  Swifters
//
//  Created by Michael Nisi on 07.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit
import Ola
import os.log

/// A super class for collection view data sources.
class DataSource: NSObject {

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
  func invalidate() {
    invalidateProbe()
    isInvalid = true
  }

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
