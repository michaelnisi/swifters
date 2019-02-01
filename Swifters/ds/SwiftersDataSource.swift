//
//  SwiftersDataSource.swift
//  Swifters
//
//  Created by Michael Nisi on 31.01.19.
//  Copyright © 2019 Michael Nisi. All rights reserved.
//

import UIKit

/// The core data source API for this app.
protocol SwiftersDataSource: class {
  associatedtype Item: Hashable
  var sections: [Array<Item>] { get set }
}

// MARK: - Updating

extension SwiftersDataSource {

  /// Commits `sections` updating `collectionView`.
  ///
  /// Keeping this demo simple, only a single section is allowed.
  ///
  /// - Parameters:
  ///   - sections: The new sections, just one actually, to commit.
  ///   - collectionView: The collection view to update.
  ///   - completionBlock: A block to execute when all operations are finished.
  func commit(
    sections newSections: [[Item]],
    updating collectionView: UICollectionView,
    completionBlock: ((Bool) -> Void)? = nil
  ) {
    dispatchPrecondition(condition: .onQueue(.main))

    precondition(newSections.count == 1, "expected one section")

    let old = sections.first ?? []
    let new = newSections.first ?? []

    let changes = diff(old: old, new: new)

    collectionView.performBatchUpdates({
      // Unpacking changes before applying them in optimally sorted order.

      var deletions = [IndexPath]()
      var insertions = [(IndexPath, Item)]()

      for change in changes {
        switch change {
        case .delete(let c):
          deletions.append(IndexPath(row: c.index, section: 0))

        case .insert(let c):
          let ip = IndexPath(row: c.index, section: 0)

          insertions.append((ip, c.item))

        case .move(let c):
          let from = IndexPath(row: c.fromIndex, section: 0)
          let to = IndexPath(row: c.toIndex, section: 0)

          deletions.append(from)
          insertions.append((to, c.item))

        case .replace(let c):
          let ip = IndexPath(row: c.index, section: 0)

          deletions.append(ip)
          insertions.append((ip, c.newItem))
        }
      }

      // Deleting in descending order.

      let itemsToDelete = deletions.sorted(by: >)

      for item in itemsToDelete {
        self.sections[0].remove(at: item.row)
      }

      collectionView.deleteItems(at: itemsToDelete)

      // Inserting in ascending order.

      let tuplesToInsert = insertions.sorted { $0.0 < $1.0 }

      for t in tuplesToInsert {
        self.sections[0].insert(t.1, at: t.0.row)
      }

      collectionView.insertItems(at: tuplesToInsert.map { $0.0 })
    }) { ok in
      completionBlock?(ok)
    }
  }

}

// MARK: - Accessing Items

extension SwiftersDataSource {

  func itemAt(indexPath: IndexPath) -> Item? {
    guard sections.indices.contains(indexPath.section) else {
      return nil
    }

    let section = sections[indexPath.section]

    guard section.indices.contains(indexPath.row) else {
      return nil
    }

    return section[indexPath.row]
  }

  var isEmpty: Bool {
    return sections.isEmpty
  }

}
