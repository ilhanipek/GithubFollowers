import UIKit

class SearchVC: UIViewController {

  let logoImageView = UIImageView()
  let userNameTextField = GFTextField()
  let callToActionButton = GFButton(backgroundColor: .green, title: "Takipçi Al")

  var isUsernameEntered : Bool {
    return !userNameTextField.text!.isEmpty
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureLogoImageView()
    configureTextfield()
    configureCallToActionButton()
    createKeyboardDissTapGesture()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  func createKeyboardDissTapGesture() {
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }

  @objc func pushFollowersListVC() {
    guard isUsernameEntered else {
      presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter username", buttonTitle: "OK")
      return
    }
    let followersListVC = FollowingListVC()
    followersListVC.userName = userNameTextField.text
    followersListVC.title = userNameTextField.text
    navigationController?.pushViewController(followersListVC, animated: true)
  }


  func configureLogoImageView() {
    view.addSubview(logoImageView)
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.image = UIImage(named: "gh-logo")!

    NSLayoutConstraint.activate([
      logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 60),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.heightAnchor.constraint(equalToConstant: 200),
      logoImageView.widthAnchor.constraint(equalToConstant: 200)
    ])
  }

  func configureTextfield() {
    view.addSubview(userNameTextField)
    userNameTextField.delegate = self
    userNameTextField.placeholder = "Enter a username"
    userNameTextField.borderStyle = .roundedRect
    userNameTextField.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
      userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      userNameTextField.heightAnchor.constraint(equalToConstant: 50)
    ])

  }

  func configureCallToActionButton() {

    view.addSubview(callToActionButton)
    callToActionButton.setTitleColor(.white, for: .normal)
    callToActionButton.backgroundColor = .systemGreen
    callToActionButton.layer.cornerRadius = 10
    callToActionButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
      callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      callToActionButton.heightAnchor.constraint(equalToConstant: 50)
    ])
    callToActionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
  }

  @objc func buttonPressed() {
    pushFollowersListVC()
  }
}

extension SearchVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    pushFollowersListVC()
    return true
  }
}
