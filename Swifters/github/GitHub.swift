//
//  GitHub.swift
//  Swifters
//
//  Created by Michael Nisi on 05.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import Foundation
import Apollo

extension ApolloClient {
  
  struct ApolloConfig: Codable {
    
    struct Service: Codable {
      
      struct Headers: Codable {
        let authorization: String
      }
      
      let url: String
      let headers: Headers
    }
    
    let service: Service
  }
  
  /// Returns the Swifters URL cache.
  ///
  /// If GitHub’s API would not be Cache-Control: no-cache, we would probably
  /// be caching more aggressively, but in this case users must be online.
  private static func configureCache(configuration: inout URLSessionConfiguration) {
    configuration.urlCache =  URLCache(
      memoryCapacity: .max, 
      diskCapacity: .max, 
      diskPath: "com.github.api"
    )
    configuration.requestCachePolicy =  .useProtocolCachePolicy
  }
  
  private static func loadConfig() throws -> ApolloConfig {
    let bundle = Bundle(for: AppDelegate.classForCoder())
    let url = bundle.url(forResource: "apollo.config", withExtension: "json")!
    let json = try Data(contentsOf: url)
    return try JSONDecoder().decode(ApolloConfig.self, from: json)
  }
  
  public convenience init() {
    var c = URLSessionConfiguration.default
    
    ApolloClient.configureCache(configuration: &c)
    
    let conf = try! ApolloClient.loadConfig()
    c.httpAdditionalHeaders = ["Authorization": conf.service.headers.authorization]
    let url = URL(string: conf.service.url)!
    let t = HTTPNetworkTransport(url: url, configuration: c)
    
    self.init(networkTransport: t)
  }
}

final class GitHub {
  static var shared = ApolloClient()
}

// MARK: - Formatting Errors

extension GitHub {

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
}

// MARK: - Formatting Dates

extension GitHub {

  private static var iso8601DateFormatter = ISO8601DateFormatter()

  private static var naturalDateFormatter: DateFormatter = {
    let df = DateFormatter()

    df.timeStyle = .none
    df.dateStyle = .medium
    df.locale = Locale(identifier: "en_US")

    return df
  }()

  static func makeDateCreatedAtString(string: String) -> String {
    let df = iso8601DateFormatter

    guard let date = df.date(from: string),
      let str = naturalDateFormatter.string(for: date) else {
      return ""
    }

    return str
  }
}
