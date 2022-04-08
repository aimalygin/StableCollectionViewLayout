//
//  StableCollectionViewFlowLayout.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 10.10.2021.
//

import Foundation
import UIKit

open class StableCollectionViewFlowLayout: UICollectionViewFlowLayout, LayoutAttributesProvider {
    /// If true then `contentOffset` will adjust when the collection view is updated (batchUpdate, insert, delete or reload).
    /// Default is true
    open var enableAutomaticContentOffsetAdjustment: Bool {
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

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        defer {
            super.prepare(forCollectionViewUpdates: updateItems)
        }
        offsetController.prepare(
            forCollectionViewUpdates: updateItems.map { CollectionViewUpdateItem(item: $0) }
        )
    }
    
    override open func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        offsetController.finalizeUpdatesWithAdjustContetnOffset(collectionView)
    }

    override public func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if !context.invalidateEverything {
            offsetController.refreshVisibleAttributes()
        }
        super.invalidateLayout(with: context)
    }
}

extension StableCollectionViewFlowLayout: CollectionViewDataProvider {
    
    open var indexPathsForVisibleItems: [IndexPath] {
        collectionView?.indexPathsForVisibleItems ?? []
    }
    
    open var numberOfSections: Int {
        collectionView?.numberOfSections ?? 0
    }
    
    open func numberOfItems(inSection section: Int) -> Int {
        collectionView?.numberOfItems(inSection: section) ?? 0
    }
    
    open var contentOffset: CGPoint {
        collectionView?.contentOffset ?? CGPoint.zero
    }
}
