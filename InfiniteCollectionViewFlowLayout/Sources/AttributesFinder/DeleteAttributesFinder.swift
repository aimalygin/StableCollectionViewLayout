//
//  DeleteHandling.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

class DeleteAttributesFinder: AbstractAttributesFinder {
    
    override func suitableLayoutAttributesForSection(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult {
        guard let layoutDataSource = layoutDataSource,
              let cachedLayoutAttributeProvider = cachedLayoutAttributeProvider else {
            return .zero
        }
        if let indexPath = updateItem.indexPathBeforeUpdate {
            if indexPath.section <= visibleState.currentTargetIndexPath.section {
                let attr = layoutDataSource.initialLayoutAttributesForAppearingSupplementaryElement(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    at: indexPath
                )
              
                let sectionItemsCount = cachedLayoutAttributeProvider.numberOfItems(inSection: indexPath.section)
                var result: [UICollectionViewLayoutAttributes] = []
                attr.withWrapped({ result.append($0) })
                let itemsAttributes = (0..<sectionItemsCount)
                    .map { IndexPath(row: $0, section: indexPath.section) }
                    .map { cachedLayoutAttributeProvider.layoutAttributesForItem(at: $0) }
                    .compactMap { $0 }
                result.append(contentsOf: itemsAttributes)
                return CalculationResult(beforeAttributes: result)
            }
        }
        return .zero
    }
    
    override func suitableLayoutAttributesForItem(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult {
        guard let cachedLayoutAttributeProvider = cachedLayoutAttributeProvider else {
            return .zero
        }
        if let indexPath = updateItem.indexPathBeforeUpdate {
            let targetIndexPath = visibleState.currentTargetIndexPath
            if indexPath.section < targetIndexPath.section ||
                (indexPath.section == targetIndexPath.section && indexPath.row < targetIndexPath.row) {
                let attr = cachedLayoutAttributeProvider.layoutAttributesForItem(at: indexPath)
                if let result = attr {
                    return CalculationResult(beforeAttributes: [result])
                }
            }
        }
        return .zero
    }
}
