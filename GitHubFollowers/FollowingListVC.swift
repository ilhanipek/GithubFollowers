//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 6.08.2024.
//

import UIKit

class FollowingListVC: UIViewController {

  var userName: String!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.prefersLargeTitles = true
    view.backgroundColor = .systemPink
    navigationController?.title = userName
  }

}
