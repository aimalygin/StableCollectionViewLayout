//
//  AttributesFinder.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 07.04.2021.
//

import Foundation

public protocol AttributesFinder {
    func suitableLayoutAttributes(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult
    
    func suitableLayoutAttributesForSection(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult
    
    func suitableLayoutAttributesForItem(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> CalculationResult
}
