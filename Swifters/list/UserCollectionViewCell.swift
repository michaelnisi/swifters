//
//  UserCollectionViewCell.swift
//  Swifters
//
//  Created by Michael Nisi on 04.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var captionLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()

    layer.cornerRadius = 16
    layer.masksToBounds = true
  }

}
