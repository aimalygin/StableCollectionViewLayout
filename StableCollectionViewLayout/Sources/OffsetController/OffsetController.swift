//
//  OffsetController.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 07.04.2021.
//

import Foundation
import UIKit

public protocol OffsetController {
    func prepare(forCollectionViewUpdates updateItems: [CollectionViewUpdateItem])
        
    func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint?
    
    func refreshVisibleAttributes()
    
    var enableAutomaticContentOffsetAdjustment: Bool { get set }
}
