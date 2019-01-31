//
//  Images.swift
//  Swifters
//
//  Created by Michael Nisi on 07.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit
import Nuke
import os.log

private let log = OSLog.disabled

final class Images {

  private static func makeImagePipeline() -> ImagePipeline {
    return ImagePipeline {
      $0.imageCache = ImageCache.shared

      let config = URLSessionConfiguration.default
      $0.dataLoader = DataLoader(configuration: config)

      let dataCache = try! DataCache(name: "ink.codes.swifters.images")
      $0.dataCache = dataCache

      $0.dataLoadingQueue.maxConcurrentOperationCount = 6
      $0.imageDecodingQueue.maxConcurrentOperationCount = 1
      $0.imageProcessingQueue.maxConcurrentOperationCount = 2

      $0.isDeduplicationEnabled = true

      $0.isProgressiveDecodingEnabled = false
    }
  }

  private init() {
    ImagePipeline.shared = Images.makeImagePipeline()
  }

  static var shared = Images()

  // MARK: - Caching URLs

  private var urls = NSCache<NSString, NSURL>()

  /// Returns URL for `string` or `nil`.
  ///
  /// Constantly initiating the same URL objects is not smart, we cache them.
  private func makeURL(string: String) -> URL? {
    guard let url = urls.object(forKey: string as NSString) as URL? else {
      if let fresh = URL(string: string) {
        urls.setObject(fresh as NSURL, forKey: string as NSString)
        return fresh
      }
      return nil
    }

    os_log("using cached URL: %@", log: log, type: .debug, url as CVarArg)

    return url
  }

  // MARK: - Loading Images

  func load(imageUrl: String, view: UIImageView) {
    guard let url = makeURL(string: imageUrl) else {
      return
    }

    Nuke.loadImage(with: url, into: view)
  }

  func cancel(displaying view: UIImageView) {
    Nuke.cancelRequest(for: view)
  }

  // MARK: - Preloading

  private let preheater = Nuke.ImagePreheater()

  private func makeURLs(imageUrls: [String]) -> [URL] {
    return imageUrls.compactMap {
      guard let url = makeURL(string: $0) else {
        return nil
      }
      return url
    }
  }

  func preload(imageUrls: [String]) {
    os_log("preloading: %@", log: log, type: .debug, imageUrls)
    preheater.startPreheating(with: makeURLs(imageUrls: imageUrls))
  }

  func cancelPreloading(imageUrls: [String]) {
    os_log("cancelling preloading: %@", log: log, type: .debug, imageUrls)
    preheater.stopPreheating(with: makeURLs(imageUrls: imageUrls))
  }

}
