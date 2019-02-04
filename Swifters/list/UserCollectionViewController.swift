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

    UserListDataSource.registerCellClasses(cv)
    
    navigationItem.title = "Swifters"
    navigationItem.largeTitleDisplayMode = .automatic

    dataSource.first = traitCollection.userInterfaceIdiom == .pad ? 15 : 10
    cv.dataSource = dataSource

    cv.prefetchDataSource = self
    cv.collectionViewLayout = ListLayout()

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
    let ds = dataSource

    dataSource.searchUsers(indexPaths: indexPaths) { sections in
      ds.commit(sections: sections, updating: cv)
    }

    return true
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    shouldSelectItemAt indexPath: IndexPath) -> Bool {
    guard case .user? = dataSource.itemAt(indexPath: indexPath) else {
      return false
    }

    return true
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let item = dataSource.itemAt(indexPath: indexPath)!

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
      guard case .user(let user, _)? = dataSource.itemAt(indexPath: $0) else {
        return nil
      }

      return user.avatarUrl
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
