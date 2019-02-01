//
//  DetailLayout.swift
//  Swifters
//
//  Created by Michael Nisi on 01.02.19.
//  Copyright © 2019 Michael Nisi. All rights reserved.
//

import UIKit

class DetailLayout: UICollectionViewFlowLayout {

  override func prepare() {
    guard let cv = collectionView else {
      return
    }

    minimumInteritemSpacing = 0
    minimumLineSpacing = 0

    cv.layoutMargins.right = 0
    cv.layoutMargins.left = 0

    let w = cv.bounds.inset(by: cv.layoutMargins).size.width

    let sv = cv.superview!
    let fullHeight = sv.bounds.inset(by: sv.layoutMargins).height

    let isMessage = cv.numberOfItems(inSection: 0) < 2

    let h: CGFloat = isMessage ? fullHeight : w

    self.itemSize = CGSize(width: w, height: h)

    self.sectionInset = UIEdgeInsets(
      top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)

    self.sectionInsetReference = .fromSafeArea
  }

}
