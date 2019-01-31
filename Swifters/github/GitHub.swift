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
