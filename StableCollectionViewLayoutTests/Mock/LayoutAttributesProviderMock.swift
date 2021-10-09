//
//  LayoutAttributesProvider.swift
//  InfiniteCollectionViewFlowLayoutTests
//
//  Created by Anton Malygin on 08.04.2021.
//

import Foundation
import UIKit
@testable import InfiniteCollectionViewFlowLayout

class LayoutAttributesProviderMock: LayoutAttributesProvider {
    
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    var attributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributes[indexPath]
    }
    
    func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributes[indexPath]
    }
    
    func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributes[elementIndexPath]
    }
    
    // Unused methods
    
    func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
}
