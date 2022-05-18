//
//  CollectionViewDataProviderMock.swift
//  InfiniteCollectionViewFlowLayoutTests
//
//  Created by Anton Malygin on 08.04.2021.
//

import Foundation
@testable import StableCollectionViewLayout
import UIKit

class CollectionViewDataProviderMock: CollectionViewDataProvider {
    var contentOffset: CGPoint = .zero

    var indexPathsForVisibleItems: [IndexPath] = []

    var numberOfSections: Int = 0

    var numberOfItemsInSection = 0

    init(indexPathsForVisibleItems: [IndexPath] = []) {
        self.indexPathsForVisibleItems = indexPathsForVisibleItems
    }

    func numberOfItems(inSection _: Int) -> Int {
        return numberOfItemsInSection
    }
}
