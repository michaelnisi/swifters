//
//  ContactCollectionViewCell.swift
//  Swifters
//
//  Created by Michael Nisi on 06.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var mailButton: UIButton!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBAction func mailButtonTouchUpInside(_ sender: Any) {
    mailButtonBlock?()
  }

  /// A block to execute when the mail button has been tapped.
  var mailButtonBlock: (() -> Void)?

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    let o = mailButton.titleEdgeInsets
    mailButton.titleEdgeInsets = UIEdgeInsets(
      top: o.top, left: 8, bottom: o.bottom, right: -8)
  }

}
