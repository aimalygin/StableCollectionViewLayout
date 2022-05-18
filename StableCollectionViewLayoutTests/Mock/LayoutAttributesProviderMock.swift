//
//  LayoutAttributesProvider.swift
//  InfiniteCollectionViewFlowLayoutTests
//
//  Created by Anton Malygin on 08.04.2021.
//

import Foundation
@testable import StableCollectionViewLayout
import UIKit

class LayoutAttributesProviderMock: LayoutAttributesProvider {
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    var attributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributes[indexPath]
    }

    func layoutAttributesForSupplementaryView(ofKind _: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributes[indexPath]
    }

    func initialLayoutAttributesForAppearingSupplementaryElement(ofKind _: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributes[elementIndexPath]
    }

    // Unused methods

    func layoutAttributesForDecorationView(ofKind _: String, at _: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind _: String, at _: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    func initialLayoutAttributesForAppearingDecorationElement(ofKind _: String, at _: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    func finalLayoutAttributesForDisappearingDecorationElement(ofKind _: String, at _: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
}
