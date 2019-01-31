//
//  DetailUserCollectionViewCell.swift
//  Swifters
//
//  Created by Michael Nisi on 10.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit

class DetailUserCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var heroImageTrailing: NSLayoutConstraint!
  @IBOutlet weak var heroImageLeading: NSLayoutConstraint!
  @IBOutlet weak var heroImageTop: NSLayoutConstraint!
  @IBOutlet weak var heroImageBottom: NSLayoutConstraint!

  @IBOutlet weak var heroImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!

  @IBAction func sleeveTouchUpInside(_ sender: Any) {
    sleeveBlock?()
  }
  
  /// A block to execute when the GitHub sleeve has been tapped.
  var sleeveBlock: (() -> Void)?

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

}
