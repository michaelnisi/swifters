//
//  ListLayout.swift
//  Swifters
//
//  Created by Michael Nisi on 01.02.19.
//  Copyright © 2019 Michael Nisi. All rights reserved.
//

import UIKit

class ListLayout: UICollectionViewFlowLayout {

  private let minColumnWidth: CGFloat = 300.0
  private let cellHeight: CGFloat = 280.0

  override func prepare() {
    super.prepare()

    guard let cv = collectionView else {
      return
    }

    minimumInteritemSpacing = 20
    minimumLineSpacing = 30

    cv.layoutMargins.right = 20
    cv.layoutMargins.left = 20

    let isMessage = cv.numberOfItems(inSection: 0) == 1

    if isMessage {
      self.itemSize = cv.bounds.inset(by: cv.layoutMargins).size
    } else {
      let availableWidth = cv.bounds.inset(by: cv.layoutMargins).width
      let maxNumColumns = Int(availableWidth / minColumnWidth)
      let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)

      self.itemSize = CGSize(width: cellWidth, height: cellHeight)
    }

    self.sectionInset = UIEdgeInsets(
      top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)

    self.sectionInsetReference = .fromSafeArea
  }

}

