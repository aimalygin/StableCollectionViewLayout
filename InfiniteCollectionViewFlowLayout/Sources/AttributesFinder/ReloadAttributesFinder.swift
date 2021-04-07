//
//  ReloadHandling.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 01.04.2021.
//

import Foundation
import UIKit

class ReloadAttributesFinder: AbstractAttributesFinder {
    
    override func suitableLayoutAttributesForSection(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult {
        guard let layoutDataSource = layoutDataSource,
              let cachedLayoutAttributeProvider = cachedLayoutAttributeProvider,
              let collectionDataSource = collectionDataSource else {
            return .zero
        }
        if let indexPathBefore = updateItem.indexPathBeforeUpdate,
            let indexPathAfter = updateItem.indexPathAfterUpdate {
            
            let attrBefore = layoutDataSource.initialLayoutAttributesForAppearingSupplementaryElement(
                ofKind: UICollectionView.elementKindSectionFooter,
                at: indexPathBefore
            )
            let attrAfter = layoutDataSource.layoutAttributesForSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                at: indexPathAfter
            )
            let sectionItemsCount = collectionDataSource.numberOfItems(inSection: indexPathAfter.section)
            
            var beforeResult: [UICollectionViewLayoutAttributes] = []
            attrBefore.withWrapped({ beforeResult.append($0) })
            
            var afterResult: [UICollectionViewLayoutAttributes] = []
            attrAfter.withWrapped({ afterResult.append($0) })
            
            let targetIndexPath = visibleState.currentTargetIndexPath
            (0..<sectionItemsCount).forEach { (itemIndex) in
                let indexPathItemBefore = IndexPath(
                    row: itemIndex,
                    section: indexPathBefore.section
                )
                let indexPathItemAfter = IndexPath(
                    row: itemIndex,
                    section: indexPathAfter.section
                )
                if indexPathAfter.section < targetIndexPath.section ||
                    (indexPathAfter.section == targetIndexPath.section && indexPathAfter.row < targetIndexPath.row) {
                    let attrBefore = cachedLayoutAttributeProvider.layoutAttributesForItem(at: indexPathItemBefore)
                    let attrAfter = layoutDataSource.layoutAttributesForItem(at: indexPathItemAfter)
                    attrAfter.withWrapped({ afterResult.append($0) })
                    attrBefore.withWrapped({ beforeResult.append($0) })
                }
            }
            return CalculationResult(
                beforeAttributes: beforeResult,
                afterAttributes: afterResult,
                modifiedVisibleState: nil
            )
        }
        return .zero
    }
    
    override func suitableLayoutAttributesForItem(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult {
        guard let layoutDataSource = layoutDataSource,
              let cachedLayoutAttributeProvider = cachedLayoutAttributeProvider else {
            return .zero
        }
        if let indexPathBefore = updateItem.indexPathBeforeUpdate,
            let indexPathAfter = updateItem.indexPathAfterUpdate {
            let attrAfter = layoutDataSource.layoutAttributesForItem(at: indexPathAfter)
            var beforeResult: [UICollectionViewLayoutAttributes] = []
            let targetIndexPath = visibleState.currentTargetIndexPath
            if indexPathAfter.section < targetIndexPath.section ||
                (indexPathAfter.section == targetIndexPath.section && indexPathAfter.row < targetIndexPath.row) {
                let attrBefore = cachedLayoutAttributeProvider.layoutAttributesForItem(at: indexPathBefore)
                attrBefore.withWrapped({ beforeResult.append($0) })
                var afterResult: [UICollectionViewLayoutAttributes] = []
                attrAfter.withWrapped({ afterResult.append($0) })
                
                return CalculationResult(
                    beforeAttributes: beforeResult,
                    afterAttributes: afterResult,
                    modifiedVisibleState: nil
                )
            }
        }
        return .zero
    }
}
