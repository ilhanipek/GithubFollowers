//
//  FollowingClient.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 21.08.2024.
//

import Foundation

protocol FollowingProtocol {
  func getFollowingsList(for username: String, pageNumber: Int, followingCount: Int) async throws -> [Following]
}

extension HTTPClient: FollowingProtocol {
  
  func getFollowingsList(for username: String, pageNumber: Int, followingCount: Int) async throws -> [Following] {
    let urlRequest = try makeUrlRequest(baseUrl: URL(string: baseUrl)!, path: "/users/\(username)/following?per_page=\(followingCount)&page=\(pageNumber)", httpMethod: .get, queryParameters: nil)
    return try await processRequest(urlRequest: urlRequest, with: [Following].self)
  }
}
