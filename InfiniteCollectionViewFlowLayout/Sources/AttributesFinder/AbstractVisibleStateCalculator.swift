//
//  UpdateHandling.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

class AbstractVisibleStateCalculator: VisibleStateCalculator {
    
    func calculate(for updateItem: CollectionViewUpdateItem,
                   visibleState: VisibleIndexesState) -> VisibleIndexesState {
        if updateItem.isSection {
            return calculateSection(updateItem, visibleState: visibleState)
        } else {
            return calculateItem(updateItem, visibleState: visibleState)
        }
    }
    
    func calculateSection(_ updateItem: CollectionViewUpdateItem,
                                            visibleState: VisibleIndexesState) -> VisibleIndexesState {
        fatalError("method \(#function) should be overrided")
    }
    
    func calculateItem(_ updateItem: CollectionViewUpdateItem,
                                         visibleState: VisibleIndexesState) -> VisibleIndexesState {
        fatalError("method \(#function) should be overrided")
    }
}
