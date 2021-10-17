//
//  VisibleIndexesStateController.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 17.10.2021.
//

import Foundation

protocol VisibleIndexesStateController {
    
    var state: VisibleIndexesState { get }
    
    func calculate(withIndexPathsForVisibleItems indexPaths: [IndexPath])
    
    func update(with item: CollectionViewUpdateItem)
}
