//
//  FollowingListViewModel.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 21.08.2024.
//

import Foundation

class FollowingViewModel {

  var followings: [Following] = []
  var errorMessage: String?
  var isLoading: Bool = false

  private let followingCore: FollowingCoreProtocol

  var didUpdateFollowings: (() -> Void)?
  var didUpdateLoadingStatus: (() -> Void)?
  var didEncounterError: ((String) -> Void)?

  init(followingCore: FollowingCoreProtocol) {
    self.followingCore = followingCore
  }

  func fetchFollowings(for username: String, pageNumber: Int, followingCount: Int) {
    isLoading = true
    didUpdateLoadingStatus?()

    Task {
      do {
        followings = try await followingCore.loadFollowingListFromServer(username: username, pageNumber: pageNumber, followingCount: followingCount)
        print(followings)
        didUpdateFollowings?()
      } catch let error as LocalizedError {
        errorMessage = error.localizedDescription
        didEncounterError?(errorMessage ?? "An unknown error occurred.")
      } catch {
        errorMessage = "An unexpected error occurred."
        didEncounterError?(errorMessage!)
      }
      isLoading = false
      didUpdateLoadingStatus?()
    }
  }

  func loadLocalFollowings() {
    followings = followingCore.loadFollowingsListFromDB()
    didUpdateFollowings?()
  }
}

