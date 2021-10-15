//
//  StableCollectionViewFlowLayout.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 10.10.2021.
//

import Foundation
import UIKit

public class StableCollectionViewFlowLayout: UICollectionViewFlowLayout, LayoutAttributesProvider {
    /// If true then `contentOffset` will adjust when the collection view is updated (batchUpdate, insert, delete or reload).
    /// Default is true
    public var enableAutomaticContentOffsetAdjustment: Bool {
        set {
            offsetController.enableAutomaticContentOffsetAdjustment = newValue
        }
        get {
            offsetController.enableAutomaticContentOffsetAdjustment
        }
    }
    
    private lazy var offsetController: OffsetController = OffsetControllerImpl(
        layoutDataSource: self,
        collectionDataSource: self
    )
    
    public init(offsetController: OffsetController? = nil) {
        super.init()
        if let controller = offsetController {
            self.offsetController = controller
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        defer {
            super.prepare(forCollectionViewUpdates: updateItems)
        }
        offsetController.prepare(forCollectionViewUpdates: updateItems)
    }
    
    override open func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        offsetController.resetOffset()
    }
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        offsetController.invalidateLayout(with: context)
        super.invalidateLayout(with: context)
    }
            
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        offsetController.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}

extension StableCollectionViewFlowLayout: CollectionViewDataProvider {
    
    public var indexPathsForVisibleItems: [IndexPath] {
        collectionView?.indexPathsForVisibleItems ?? []
    }
    
    public var numberOfSections: Int {
        collectionView?.numberOfSections ?? 0
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        collectionView?.numberOfItems(inSection: section) ?? 0
    }
    
    public var contentOffset: CGPoint {
        collectionView?.contentOffset ?? CGPoint.zero
    }
}
