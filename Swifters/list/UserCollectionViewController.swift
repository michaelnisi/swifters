//
//  UserCollectionViewController.swift
//  Swifters
//
//  Created by Michael Nisi on 04.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewController

final class UserCollectionViewController: UICollectionViewController {

  private var dataSource = UserListDataSource()

  private static func makeSectionInset(collectionView: UICollectionView) -> UIEdgeInsets {
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let o = layout.sectionInset

    guard collectionView.traitCollection.containsTraits(in:
      UITraitCollection(traitsFrom: [
      UITraitCollection(horizontalSizeClass: .regular),
      UITraitCollection(verticalSizeClass: .regular)
    ])) else {
      return o
    }

    return UIEdgeInsets(top: o.top, left: 24, bottom: o.bottom, right: 24)
  }

  /// Updates and may load more than 10 items, making sure sure we have enough
  /// items to fill the view. On iPad, 10 may not be enough, we are prefetching
  /// based on visible items.
  ///
  /// Only required for initial population. In production, we would probably
  /// adjust our query limit relative to the available space. The current
  /// `first: 10` is appropriate for iPhone but tight for larger screens.
  private func updateAndFill() {
    let cv = collectionView!
    update() {
      self.update(indexPaths: cv.indexPathsForVisibleItems)
    }
  }

  @objc func refreshControlValueChanged(sender: UIRefreshControl) {
    guard sender.isRefreshing else {
      return
    }
    
    sender.beginRefreshing()

    updateAndFill()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let cv = collectionView else {
      fatalError("collectionView expected")
    }

    DataSource.registerCellClasses(cv)
    
    // Do any additional setup after loading the view.

    navigationItem.title = "Swifters"
    navigationItem.largeTitleDisplayMode = .automatic

    let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumInteritemSpacing = 20
    layout.minimumLineSpacing = 30
    layout.sectionInset = UserCollectionViewController.makeSectionInset(collectionView: cv)

    cv.dataSource = dataSource
    cv.prefetchDataSource = self

    let rc = UIRefreshControl()
    rc.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
    cv.refreshControl = rc
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    updateAndFill()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    dataSource.invalidateProbe()
  }

  /// Invalidates the data source.
  ///
  /// This illustrates nicely, how having two references, `dataSource` and
  /// `collectionView.dataSource`, for the *same* thing are a terrible idea.
  func invalidateDataSource() {
    let cv = collectionView!

    dataSource.invalidate()

    let newDataSource = UserListDataSource(message: "Swipe down to refresh.")

    cv.dataSource = newDataSource
    dataSource = newDataSource

    cv.performBatchUpdates({ cv.reloadSections([0]) }) { ok in assert(ok) }
  }

  /// Fetches users if the data source hasn’t been initially populated with
  /// users or if `indexPaths` references its last item.
  @discardableResult
  func update(
    indexPaths: [IndexPath]? = nil,
    completionBlock: (() -> Void)? = nil
  ) -> Bool {
    guard dataSource.isEmpty || indexPaths != nil else {
      completionBlock?()
      return false
    }

    let cv = collectionView!

    dataSource.searchUsers(indexPaths: indexPaths) { sections in
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
        completionBlock?()
      }
    }

    return true
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    shouldSelectItemAt indexPath: IndexPath) -> Bool {
    switch dataSource.dataSourceItem(matching: indexPath) {
    case .user:
      return true
    case .detail, .message, .contact:
      return false
    }
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let item = dataSource.dataSourceItem(matching: indexPath)

    guard case .user = item,
      let vc = storyboard?.instantiateViewController(
      withIdentifier: "UserDetailsID") as? DetailCollectionViewController else {
      return
    }

    vc.update(using: item)

    navigationController?.pushViewController(vc, animated: true)
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView.bounds.maxY == scrollView.contentSize.height else {
      return
    }

    update(indexPaths: collectionView!.indexPathsForVisibleItems)
  }

  override func scrollViewDidEndDragging(
    _ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    // Allowing refresh control to finish animating.
    DispatchQueue.main.async {
      guard let rc = scrollView.refreshControl, rc.isRefreshing else {
        return
      }

      rc.endRefreshing()
    }
  }

}

// MARK: UICollectionViewDataSourcePrefetching

extension UserCollectionViewController: UICollectionViewDataSourcePrefetching {

  private func makeAvatarUrls(indexPaths: [IndexPath]) -> [String] {
    return indexPaths.compactMap {
      let item = dataSource.dataSourceItem(matching: $0)
      switch item {
      case .user(let user, _):
        return user.avatarUrl
      case .contact, .detail, .message:
        return nil
      }
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    prefetchItemsAt indexPaths: [IndexPath]
  ) {
    update(indexPaths: indexPaths)

    // Preloading images.

    let avatarUrls = makeAvatarUrls(indexPaths: indexPaths)
    Images.shared.preload(imageUrls: avatarUrls)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cancelPrefetchingForItemsAt indexPaths: [IndexPath]
  ) {
    let avatarUrls = makeAvatarUrls(indexPaths: indexPaths)
    Images.shared.cancelPreloading(imageUrls: avatarUrls)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {

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
