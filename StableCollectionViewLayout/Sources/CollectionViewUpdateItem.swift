//
//  CollectionViewUpdateItem.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

public struct CollectionViewUpdateItem: Equatable {
    let indexPathBeforeUpdate: IndexPath?
    let indexPathAfterUpdate: IndexPath?
    let updateAction: UICollectionViewUpdateItem.Action
    let isSection: Bool
    
    var isRow: Bool {
        !isSection
    }
}

extension CollectionViewUpdateItem {
    init(item: UICollectionViewUpdateItem) {
        self.init(
            indexPathBeforeUpdate: item.indexPathBeforeUpdate,
            indexPathAfterUpdate: item.indexPathAfterUpdate,
            updateAction: item.updateAction
        )
    }
    
    init(
        indexPathBeforeUpdate: IndexPath?,
        indexPathAfterUpdate: IndexPath?,
        updateAction: UICollectionViewUpdateItem.Action
    ) {
        let isSection = indexPathBeforeUpdate?.row == Int.max ||
            indexPathAfterUpdate?.row == Int.max
        
        self.init(
            indexPathBeforeUpdate: indexPathBeforeUpdate,
            indexPathAfterUpdate: indexPathAfterUpdate,
            updateAction: updateAction,
            isSection: isSection
        )
    }
}
