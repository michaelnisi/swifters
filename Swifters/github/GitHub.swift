//
//  GitHub.swift
//  Swifters
//
//  Created by Michael Nisi on 05.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import Foundation
import Apollo

final class GitHub {

  static var shared: ApolloClient = {
    let c = URLSessionConfiguration.default

    let token: String = UserDefaults.standard.string(forKey: "token")!

    c.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]

    let url = URL(string: "https://api.github.com/graphql")!
    let t = HTTPNetworkTransport(url: url, configuration: c)

    return ApolloClient(networkTransport: t)
  }()

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

  static func makeDateCreatedAtString(string: String) -> String {
    let df = apolloDateFormatter

    guard let date = df.date(from: string),
      let str = naturalDateFormatter.string(for: date) else {
      return ""
    }

    return str
  }

}
