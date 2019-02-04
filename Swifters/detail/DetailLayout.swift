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

    defer {
      sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
      sectionInsetReference = .fromSafeArea
    }

    let aw = cv.bounds.inset(by: cv.layoutMargins).width
    let sv = cv.superview!
    let ah = cv.superview!.bounds.inset(by: sv.layoutMargins).height

    // Filling available space if there is just one item.
    guard cv.numberOfItems(inSection: 0) != 1 else {
      itemSize = CGSize(width: aw, height: ah)
      return
    }

    let w = (aw > ah ? aw / 2 : aw).rounded(.down)
    let h: CGFloat = min(ah * 0.7, w).rounded(.down)

    itemSize = CGSize(width: w, height: h)
  }


}
