//
//  UpdateHandling.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

class AbstractAttributesFinder: AttributesFinder {
    weak var layoutDataSource: LayoutAttributesProvider?
    weak var collectionDataSource: CollectionViewDataProvider?
    weak var cachedLayoutAttributeProvider: CachedLayoutAttributesProvider?
    
    init(layoutDataSource: LayoutAttributesProvider,
         collectionDataSource: CollectionViewDataProvider?,
         cachedLayoutAttributeProvider: CachedLayoutAttributesProvider?) {
        self.layoutDataSource = layoutDataSource
        self.collectionDataSource = collectionDataSource
        self.cachedLayoutAttributeProvider = cachedLayoutAttributeProvider
    }
    
    func suitableLayoutAttributes(_ updateItem: CollectionViewUpdateItem,
                                  visibleState: VisibleIndexesState) -> CalculationResult {
        if updateItem.isSection {
            return suitableLayoutAttributesForSection(updateItem, visibleState: visibleState)
        } else {
            return suitableLayoutAttributesForItem(updateItem, visibleState: visibleState)
        }
    }
    
    func suitableLayoutAttributesForSection(_ updateItem: CollectionViewUpdateItem,
                                            visibleState: VisibleIndexesState) -> CalculationResult {
        fatalError("method \(#function) should be overrided")
    }
    
    func suitableLayoutAttributesForItem(_ updateItem: CollectionViewUpdateItem,
                                         visibleState: VisibleIndexesState) -> CalculationResult {
        fatalError("method \(#function) should be overrided")
    }
}
