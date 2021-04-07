//
//  InfiniteCollectionViewFlowLayout.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 17.02.2021.
//

import Foundation
import UIKit

public class InfiniteCollectionViewFlowLayout: UICollectionViewFlowLayout, LayoutAttributesProvider {
    /// If true then `contentOffset` will adjust when the collection view is updated (batchUpdate, insert, delete or reload).
    /// Default is true
    public var enableAutomaticContentOffsetAdjustment = true
    
    private var offset: CGFloat?
    
    private lazy var offsetController: OffsetController = OffsetControllerImpl(
        layoutDataSource: self,
        collectionDataSource: self,
        minimumLineSpacing: minimumLineSpacing,
        minimumInteritemSpacing: minimumInteritemSpacing,
        scrollDirection: scrollDirection
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
    
    public override var scrollDirection: UICollectionView.ScrollDirection {
        didSet {
            offsetController.scrollDirection = scrollDirection
        }
    }
    
    public override var minimumLineSpacing: CGFloat {
        didSet {
            offsetController.minimumLineSpacing = minimumLineSpacing
        }
    }
    
    public override var minimumInteritemSpacing: CGFloat {
        didSet {
            offsetController.minimumInteritemSpacing = minimumInteritemSpacing
        }
    }
          
    override open func prepare() {
      super.prepare()
      if offsetController.isLayoutAttributeEmpty {
        offsetController.refreshAttributes()
      }
    }
        
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        defer {
            super.prepare(forCollectionViewUpdates: updateItems)
        }
        guard
            let collectionView = self.collectionView, enableAutomaticContentOffsetAdjustment else {
                return
        }
        
        let previousContentOffset = scrollDirection == .vertical ?
            collectionView.contentOffset.y : collectionView.contentOffset.x
        let diff = offsetController.calculateOffsetDiff(
            for: updateItems.map({ CollectionViewUpdateItem(item: $0) })
        )
        guard diff != 0 else {
            return
        }
        offset = previousContentOffset + diff
    }
    
    override open func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        offset = nil
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // workaround for iOS 12 and less
        // https://stackoverflow.com/questions/19207924/uicollectionview-exception-in-uicollectionviewlayoutattributes-from-ios7/37563336
        
        if #available(iOS 13, *) {
            let value = super.shouldInvalidateLayout(forBoundsChange: newBounds)
            return value
        }
        return true
    }
            
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let offset = offset else {
            return proposedContentOffset
        }
        if scrollDirection == .vertical {
            return CGPoint(x: proposedContentOffset.x,
                           y: offset)
        } else {
            return CGPoint(x: offset,
                           y: proposedContentOffset.y)
        }
    }
}

extension InfiniteCollectionViewFlowLayout: CollectionViewDataProvider {
    
    public var indexPathsForVisibleItems: [IndexPath] {
        collectionView?.indexPathsForVisibleItems ?? []
    }
    
    public var numberOfSections: Int {
        collectionView?.numberOfSections ?? 0
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        collectionView?.numberOfItems(inSection: section) ?? 0
    }
}
