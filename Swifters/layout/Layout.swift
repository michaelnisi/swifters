//
//  Layout.swift
//  Swifters
//
//  Created by Michael Nisi on 08.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit

private extension UICollectionView {

  var safeContentBounds: CGSize {
    let l = safeAreaInsets.left + contentInset.left
    let r = safeAreaInsets.right + contentInset.right

    let w = bounds.width - l - r

    let t = safeAreaInsets.top + contentInset.top
    let b = safeAreaInsets.bottom + contentInset.bottom

    let h = bounds.height - t - b

    return CGSize(width: w, height: h)
  }

  /// The width of the UICollectionView minus the section insets left and right
  /// values, minus the content insets left and right values.
  var maxWidth: CGFloat {
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    return safeContentBounds.width -
      layout.sectionInset.left - layout.sectionInset.right
  }

  var maxHeight: CGFloat {
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    return safeContentBounds.height -
      layout.sectionInset.top - layout.sectionInset.bottom
  }

}

struct Layout {

  /// Returns size for item at `indexPath`.
  static func makeItemSize(
    dataSource: DataSource,
    collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    let item = dataSource.dataSourceItem(matching: indexPath)

    switch item {
    case .detail, .contact:
      let i: CGFloat = collectionView.traitCollection.containsTraits(in:
        UITraitCollection(traitsFrom: [
          UITraitCollection(horizontalSizeClass: .regular)
      ])) ? 2 : 1

      let spacing = layout.minimumInteritemSpacing * (i - 1)

      let s = collectionView.maxWidth / i - spacing

      return CGSize(width: s, height: s)

    case .user:
      let i: CGFloat = collectionView.traitCollection.containsTraits(in:
        UITraitCollection(traitsFrom: [
          UITraitCollection(horizontalSizeClass: .regular)
      ])) ? 3 : 1

      let spacing = layout.minimumInteritemSpacing * max(i - 1, 2)

      let s = min(collectionView.maxWidth / i, 414) - spacing

      return CGSize(width: s, height: min(s, 280))
      
    case .message:
      let w = min(collectionView.maxWidth, collectionView.maxHeight)

      return CGSize(width: w, height: w)
    }
  }

}

