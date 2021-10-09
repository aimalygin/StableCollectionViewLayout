//
//  CollectionViewUpdateItem.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

public struct CollectionViewUpdateItem {
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
        let isSection = item.indexPathBeforeUpdate?.row == Int.max ||
            item.indexPathAfterUpdate?.row == Int.max
        self.init(
            indexPathBeforeUpdate: item.indexPathBeforeUpdate,
            indexPathAfterUpdate: item.indexPathAfterUpdate,
            updateAction: item.updateAction,
            isSection: isSection
        )
    }
}
