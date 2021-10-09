//
//  AttributesFinder.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 07.04.2021.
//

import Foundation

public protocol VisibleStateCalculator {
    func calculate(
        for updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> VisibleIndexesState
    
    func calculateSection(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> VisibleIndexesState
    
    func calculateItem(
        _ updateItem: CollectionViewUpdateItem,
        visibleState: VisibleIndexesState
    ) -> VisibleIndexesState
}
