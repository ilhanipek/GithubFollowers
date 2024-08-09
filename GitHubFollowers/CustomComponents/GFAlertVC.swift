//
//  GFAlertVC.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 7.08.2024.
//

import UIKit

class GFAlertVC: UIViewController {

  let alertContainerView = UIView()
  let titleLabel = GFTitleLabel(alignment: .center, fontSize: 20)
  let bodyLabel = GFBodyLabel(alignment: .center)
  let actionButton = GFButton(backgroundColor: .systemPink, title: "Ok")

  var alertTitle : String?
  var message : String?
  var buttonTitle : String?

  let padding : CGFloat = 20

  init(alertTitle: String, message: String, buttonTitle: String) {
    super.init(nibName: nil, bundle: nil)
    self.alertTitle = alertTitle
    self.message = message
    self.buttonTitle = buttonTitle
    configureAlertContainer()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    override func viewDidLoad() {
        super.viewDidLoad()

      view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
      configureAlertContainer()
      configureTitleLabel()
      configureMessageLabel()
      configureActionButton()
    }

  func configureAlertContainer() {
    view.addSubview(alertContainerView)
    alertContainerView.translatesAutoresizingMaskIntoConstraints = false
    alertContainerView.backgroundColor = .white
    alertContainerView.layer.borderColor = UIColor.white.cgColor
    alertContainerView.layer.cornerRadius = 16
    alertContainerView.layer.borderWidth = 2

    NSLayoutConstraint.activate([
      alertContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      alertContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      alertContainerView.widthAnchor.constraint(equalToConstant: 280),
      alertContainerView.heightAnchor.constraint(equalToConstant: 220)
    ])
  }

  func configureTitleLabel() {
    alertContainerView.addSubview(titleLabel)
    titleLabel.textColor = .systemGray3
    titleLabel.text = alertTitle ?? "Something went wrong"

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 28)
    ])
  }

  func configureActionButton() {
    alertContainerView.addSubview(actionButton)
    actionButton.setTitle("Ok", for: .normal)
    actionButton.setTitleColor(.white, for: .normal)
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    actionButton.layer.cornerRadius = 10
    actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    NSLayoutConstraint.activate([
      actionButton.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor, constant: -padding),
      actionButton.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
      actionButton.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding),
      actionButton.heightAnchor.constraint(equalToConstant: 44)
    ])
  }

  @objc func dismissVC() {
    dismiss(animated: true)
  }

  func configureMessageLabel() {
    alertContainerView.addSubview(bodyLabel)
    bodyLabel.textColor = .systemGray5
    bodyLabel.text = message ?? "Undefined alert situation"
    bodyLabel.numberOfLines = 4

    NSLayoutConstraint.activate([
      bodyLabel.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor, constant: -50),
      bodyLabel.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: 8),
      bodyLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
      bodyLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding)
    ])
  }
}
