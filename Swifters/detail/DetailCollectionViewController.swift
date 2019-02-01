//
//  DetailCollectionViewController.swift
//  Swifters
//
//  Created by Michael Nisi on 04.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewController

class DetailCollectionViewController: UICollectionViewController {

  private var dataSource = DetailDataSource(sections: [[.message("Loading…")]])

  var item: UserListDataSource.Item!

  func update(using item: UserListDataSource.Item) {
    // Setting our title before we’re getting pushed.
    if case .user(let user, _) = item {
      title = user.name
    }

    self.item = item
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let cv = collectionView!
    let ds = dataSource

    dataSource.update(using: item) { sections in
      ds.commit(sections: sections, updating: cv)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .automatic

    guard let cv = collectionView else {
      fatalError("collectionView expected")
    }

    DetailDataSource.registerCellClasses(cv)

    cv.collectionViewLayout = DetailLayout()
    cv.dataSource = dataSource
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    dataSource.invalidate()
  }

  /// Tracks the original navigation bar height, before scrolling, for the
  /// image zoom effect during scroll.
  var originalNavigationBarHeight: CGFloat?

  override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    originalNavigationBarHeight = navigationController?
      .navigationBar.bounds.height
  }
}

// MARK: - UIScrollViewDelegate

extension DetailCollectionViewController {

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let visibleCells = collectionView?.visibleCells,
      let navigationBar = navigationController?.navigationBar,
      let h = originalNavigationBarHeight,
      let t = visibleCells.first(where: {
        $0 is DetailUserCollectionViewCell
      }) as? DetailUserCollectionViewCell else {
      return
    }

    let c = min(h - navigationBar.bounds.size.height, 0)

    t.heroImageTop.constant = c
    t.heroImageBottom.constant = c
    t.heroImageLeading.constant = c
    t.heroImageTrailing.constant = c
  }

}
