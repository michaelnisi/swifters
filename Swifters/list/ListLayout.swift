//
//  ListLayout.swift
//  Swifters
//
//  Created by Michael Nisi on 01.02.19.
//  Copyright © 2019 Michael Nisi. All rights reserved.
//

import UIKit

class ListLayout: UICollectionViewFlowLayout {

  override func prepare() {
    super.prepare()

    guard let cv = collectionView else {
      return
    }

    let s: CGFloat = 20.0

    minimumInteritemSpacing = s
    minimumLineSpacing = 30

    cv.layoutMargins.right = s
    cv.layoutMargins.left = s

    defer {
      sectionInset = UIEdgeInsets(top: s, left: 0.0, bottom: 0.0, right: 0.0)
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

    let maxNumColumns = Int(aw / 300)
    let w = (aw / CGFloat(maxNumColumns)).rounded(.down)

    itemSize = CGSize(width: w, height: 280)
  }

}

