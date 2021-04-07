//
//  InsertHandling.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

class InsertAttributesFinder: AbstractAttributesFinder {
    
    override func suitableLayoutAttributesForSection(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult {
        guard let layoutDataSource = layoutDataSource,
              let collectionDataSource = collectionDataSource else {
            return .zero
        }
        if let indexPath = updateItem.indexPathAfterUpdate {
            let targetIndexPath = visibleState.currentTargetIndexPath
            let attr = layoutDataSource.layoutAttributesForSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                at: indexPath
            )
            var modifiedVisibleState = visibleState
            if indexPath.section <= targetIndexPath.section {
                modifiedVisibleState = visibleState.incrementedRows()
            }
            var result: [UICollectionViewLayoutAttributes] = []
            attr.withWrapped({ result.append($0) })
            if indexPath.section < modifiedVisibleState.currentTargetIndexPath.section {
                let sectionItemsCount = collectionDataSource.numberOfItems(inSection: indexPath.section)
                
                let itemsAttributes = (0..<sectionItemsCount)
                    .map { IndexPath(row: $0, section: indexPath.section) }
                    .map { layoutDataSource.layoutAttributesForItem(at: $0) }
                    .compactMap { $0 }
                result.append(contentsOf: itemsAttributes)
            }
            return CalculationResult(
                afterAttributes: result,
                modifiedVisibleState: modifiedVisibleState
            )
        }
        return .zero
    }
    
    override func suitableLayoutAttributesForItem(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult {
        guard let layoutDataSource = layoutDataSource else {
            return .zero
        }
        if let indexPath = updateItem.indexPathAfterUpdate {
            let attr = layoutDataSource.layoutAttributesForItem(at: indexPath)
            var modifiedVisibleState = visibleState
            if (indexPath.section == modifiedVisibleState.currentTargetIndexPath.section &&
                    indexPath.row <= modifiedVisibleState.currentTargetIndexPath.row) {
                modifiedVisibleState = visibleState.incrementedRows()
            }
            let targetIndexPath = modifiedVisibleState.currentTargetIndexPath
            if indexPath.section < targetIndexPath.section ||
                (indexPath.section == targetIndexPath.section && indexPath.row < targetIndexPath.row) {
                if let result = attr {
                    return CalculationResult(
                        afterAttributes: [result],
                        modifiedVisibleState: modifiedVisibleState
                    )
                }
            }
        }
        return .zero
    }
}
