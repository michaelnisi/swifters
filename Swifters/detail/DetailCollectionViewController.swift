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

  var item: DataSourceItem!

  func update(using item: DataSourceItem) {
    // Setting our title before we’re getting pushed.
    if case .user(let user, _) = item {
      title = user.name
    }

    self.item = item
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let cv = collectionView!

    dataSource.update(using: item) { sections in
      cv.performBatchUpdates({
        // Index out of range intentionally traps here!
        let old = self.dataSource.sections[0]
        let changes = diff(old: old, new: sections[0])

        self.dataSource.sections = sections

        for change in changes {
          switch change {
          case .insert(let change):
            let ip = IndexPath(row: change.index, section: 0)
            cv.insertItems(at: [ip])
          case .delete(let change):
            let ip = IndexPath(row: change.index, section: 0)
            cv.deleteItems(at: [ip])
          case .replace, .move:
            fatalError("not implemented yet")
          }
        }
      }) { ok in
        assert((ok))
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .automatic

    guard let cv = collectionView else {
      fatalError("collectionView expected")
    }

    DataSource.registerCellClasses(cv)

    let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0

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

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailCollectionViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return Layout.makeItemSize(
      dataSource: dataSource,
      collectionView: collectionView,
      layout: collectionViewLayout,
      sizeForItemAt: indexPath
    )
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
