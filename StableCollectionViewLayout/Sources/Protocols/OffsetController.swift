//
//  OffsetController.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 07.04.2021.
//

import Foundation
import UIKit

public protocol OffsetController {
    func resetOffset()
    func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem])
    func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint
    func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext)
    
    var enableAutomaticContentOffsetAdjustment: Bool { get set }
}
