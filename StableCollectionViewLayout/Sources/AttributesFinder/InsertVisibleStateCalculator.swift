//
//  InsertHandling.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

class InsertVisibleStateCalculator: AbstractVisibleStateCalculator {
    
    override func calculateSection(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> VisibleIndexesState {
        if let indexPath = updateItem.indexPathAfterUpdate {
            let targetIndexPath = visibleState.currentTargetIndexPath
            var modifiedVisibleState = visibleState
            if indexPath.section <= targetIndexPath.section {
                modifiedVisibleState = visibleState.incrementedSections()
            }
            return modifiedVisibleState
        }
        return visibleState
    }
    
    override func calculateItem(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> VisibleIndexesState {
        if let indexPath = updateItem.indexPathAfterUpdate {
            var modifiedVisibleState = visibleState
            if (indexPath.section == modifiedVisibleState.currentTargetIndexPath.section &&
                    indexPath.row <= modifiedVisibleState.currentTargetIndexPath.row) {
                modifiedVisibleState = visibleState.incrementedRows()
            }
            return modifiedVisibleState
        }
        return visibleState
    }
}
