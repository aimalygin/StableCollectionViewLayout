//
//  LayoutAttributesCache.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 06.04.2021.
//

import UIKit

class LayoutAttributesCache: CachedLayoutAttributesProvider {
    
    var cachedLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    var isEmpty: Bool {
        cachedLayoutAttributes.isEmpty
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        cachedLayoutAttributes.keys.filter({ $0.section == section }).count
    }
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedLayoutAttributes[indexPath]
    }
    
    func update(
        with item: CollectionViewUpdateItem,
        attributes: UICollectionViewLayoutAttributes?
    ) {
        cachedLayoutAttributes.update(
            with: item,
            attributes: attributes
        )
    }
}
