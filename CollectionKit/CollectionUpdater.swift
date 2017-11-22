//
//  CollectionUpdater.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 22.11.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation

final class CollectionUpdater {
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func apply(change: AbstractCollectionUpdate) {
        switch change {
        case let update as ItemChange:
            handleItemUpdate(update: update)
        case let update as SectionUpdate:
            handleSectionUpdate(update: update)
        default: break
        }
    }
    
    func apply(changes: [AbstractCollectionUpdate]) {
        changes.forEach { [unowned self] (change) in
            self.apply(change: change)
        }
    }
    
    private func handleItemUpdate(update: ItemChange) {
        switch update.type {
        case .reload:
            collectionView.reloadItems(at: [update.indexPath])
            break
        case .insert:
            collectionView.insertItems(at: [update.indexPath])
            break
        case .delete:
            collectionView.deleteItems(at: [update.indexPath])
            break
        }
    }
    
    private func handleSectionUpdate(update: SectionUpdate) {
        switch update.type {
        case .reload:
            collectionView.reloadSections([update.index])
            break
        case .insert:
            collectionView.insertSections([update.index])
            break
        case .delete:
            collectionView.deleteSections([update.index])
            break
        }
    }
}
