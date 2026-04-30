//
//  CollectionViewDataProvider.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 06.04.2021.
//

import CoreGraphics
import Foundation

public protocol CollectionViewDataProvider: AnyObject {
    var numberOfSections: Int { get }

    var indexPathsForVisibleItems: [IndexPath] { get }

    var contentOffset: CGPoint { get }

    func numberOfItems(inSection section: Int) -> Int
}

public extension CollectionViewDataProvider {
    func isValid(indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let item = indexPath.item

        guard section >= 0, item >= 0 else {
            return false
        }

        guard section < numberOfSections else {
            return false
        }

        return item < numberOfItems(inSection: section)
    }
}
