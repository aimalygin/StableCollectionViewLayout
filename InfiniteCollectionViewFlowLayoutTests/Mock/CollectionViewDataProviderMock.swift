//
//  CollectionViewDataProviderMock.swift
//  InfiniteCollectionViewFlowLayoutTests
//
//  Created by Anton Malygin on 08.04.2021.
//

import Foundation
import UIKit
@testable import InfiniteCollectionViewFlowLayout

class CollectionViewDataProviderMock: CollectionViewDataProvider {
    
    var indexPathsForVisibleItems: [IndexPath] = []
    
    var numberOfSections: Int = 0
    
    func numberOfItems(inSection section: Int) -> Int {
        return 0
    }
}
