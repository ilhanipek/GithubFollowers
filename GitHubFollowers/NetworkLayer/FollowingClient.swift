//
//  FollowingClient2.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 21.08.2024.
//

import Foundation

protocol FollowingCoreProtocol {
  // DB
  func loadFollowingListFromServer(username: String, pageNumber: Int, followingCount: Int) async throws -> [Following]
  // Server
  func loadFollowingsListFromDB() -> [Following]
}

protocol FollowingDB {
  func getFollowingList() -> [Following]
}

protocol FollowingService {
  func getFollowingsList(for username: String, pageNumber: Int, followingCount: Int) async throws -> [Following]
}

extension HTTPClient: FollowingDB {

  static let followings: [Following] = [
    Following(login: "Ilhan", avatarUrl: "www"),
    Following(login: "Desti", avatarUrl: "www")
  ]

  func getFollowingList() -> [Following] {
    return HTTPClient.followings
  }
}

extension HTTPClient: FollowingService {
  func getFollowingsList(for username: String, pageNumber: Int, followingCount: Int) async throws -> [Following] {
    let urlRequest = try makeUrlRequest(baseUrl: URL(string: baseUrl)!, path: "/users/\(username)/following?per_page=\(followingCount)&page=\(pageNumber)", httpMethod: .get, queryParameters: nil)
    return try await processRequest(urlRequest: urlRequest, with: [Following].self)
  }
}

class FollowingCore: FollowingCoreProtocol {

  private let localDataSource: FollowingDB
  private let remoteDataSource: FollowingService

  init(localDataSource: FollowingDB, remoteDataSource: FollowingService) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }

  func loadFollowingListFromServer(username: String, pageNumber: Int, followingCount: Int) async throws -> [Following] {
    do {
      let serverFollowingList = try await remoteDataSource.getFollowingsList(for: username, pageNumber: pageNumber, followingCount: followingCount)
      return serverFollowingList
    } catch let error as NetworkError {
      print("Network Error: \(error.localizedDescription)")
      throw error
    } catch {
      print("Unexpected Error: \(error.localizedDescription)")
      throw NetworkError.unknown(error)
    }
  }

  func loadFollowingsListFromDB() -> [Following] {
    return localDataSource.getFollowingList()
  }
}

