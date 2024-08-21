//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 6.08.2024.
//

import UIKit

class FollowingListVC: UIViewController {

  var userName: String!
  let followingVM = FollowingViewModel(followingCore: FollowingCore(remoteDataSource: HTTPClient.httpClient))
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.prefersLargeTitles = true
    view.backgroundColor = .systemPink
    navigationController?.title = userName
    followingVM.fetchFollowings(for: userName, pageNumber: 1, followingCount: 20)
  }
  
  override func viewWillAppear(_ animated: Bool) {

  }
}
