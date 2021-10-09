//
//  DeleteHandling.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

class DeleteVisibleStateCalculator: AbstractVisibleStateCalculator {
    
    override func calculateSection(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> VisibleIndexesState {
        if let indexPath = updateItem.indexPathBeforeUpdate {
            let targetIndexPath = visibleState.currentTargetIndexPath
            var modifiedVisibleState = visibleState
            if indexPath.section <= targetIndexPath.section {
                modifiedVisibleState = visibleState.decrementedSections()
            }
            return modifiedVisibleState
        }
        return visibleState
    }
    
    override func calculateItem(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> VisibleIndexesState {
        if let indexPath = updateItem.indexPathBeforeUpdate {
            var modifiedVisibleState = visibleState
            let targetIndexPath = visibleState.currentTargetIndexPath
            if indexPath.section < targetIndexPath.section ||
                (indexPath.section == targetIndexPath.section && indexPath.row < targetIndexPath.row) {
                if (indexPath.section == modifiedVisibleState.currentTargetIndexPath.section &&
                        indexPath.row <= modifiedVisibleState.currentTargetIndexPath.row) {
                    modifiedVisibleState = visibleState.decrementedRows()
                }
            }
            return modifiedVisibleState
        }
        return visibleState
    }
}
