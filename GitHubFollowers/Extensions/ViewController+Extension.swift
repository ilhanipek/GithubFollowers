//
//  ViewController+Extension.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 8.08.2024.
//

import Foundation
import UIKit

extension UIViewController {

  func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
    DispatchQueue.main.async {
      let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
      alertVC.modalPresentationStyle = .overFullScreen
      alertVC.modalTransitionStyle = .crossDissolve
      self.present(alertVC, animated: true)
    }
  }
}
