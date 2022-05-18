//
//  CollectionViewDataProviderMock.swift
//  InfiniteCollectionViewFlowLayoutTests
//
//  Created by Anton Malygin on 08.04.2021.
//

import Foundation
import UIKit
@testable import StableCollectionViewLayout

class CollectionViewDataProviderMock: CollectionViewDataProvider {
    var contentOffset: CGPoint = .zero
    
    var indexPathsForVisibleItems: [IndexPath] = []
    
    var numberOfSections: Int = 0
    
    var numberOfItemsInSection = 0
    
    init(indexPathsForVisibleItems: [IndexPath] = []) {
        self.indexPathsForVisibleItems = indexPathsForVisibleItems
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return numberOfItemsInSection
    }
}
