//
//  GFTitleLabel.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 7.08.2024.
//

import UIKit

class GFTitleLabel: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  init(alignment: NSTextAlignment, fontSize: CGFloat) {
    super.init(frame: .zero)
    self.textAlignment = alignment
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    configure()
  }

  private func configure() {
    textColor = .label
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.9
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
