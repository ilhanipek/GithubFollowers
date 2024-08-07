//
//  GFBodyLabel.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 7.08.2024.
//

import UIKit

class GFBodyLabel: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  init(alignment: NSTextAlignment) {
    super.init(frame: .zero)
    self.textAlignment = alignment
    configure()
  }

  private func configure() {
    textColor = .secondaryLabel
    font = UIFont.preferredFont(forTextStyle: .body)
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.75
    lineBreakMode = .byWordWrapping
    translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
