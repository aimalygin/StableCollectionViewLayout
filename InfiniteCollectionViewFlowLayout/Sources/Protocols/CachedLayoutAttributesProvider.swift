//
//  CachedLayoutAttributesProvider.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 06.04.2021.
//

import Foundation
import UIKit

public protocol CachedLayoutAttributesProvider: class {
    func numberOfItems(inSection section: Int) -> Int
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
}
