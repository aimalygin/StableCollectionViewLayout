//
//  OffsetCalculator.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

public class OffsetControllerImpl: OffsetController {
    
    public var enableAutomaticContentOffsetAdjustment = true
    
    private weak var layoutDataSource: LayoutAttributesProvider?
    private weak var collectionDataSource: CollectionViewDataProvider?
    
    private var visibleState = VisibleIndexesState()
    
    private let insertCalculator: InsertVisibleStateCalculator
    private let deleteCalculator: DeleteVisibleStateCalculator
    
    private var previousVisibleAttributes: [IndexPath: CGRect] = [:]
    private var offset: CGPoint?
    
    init(
        layoutDataSource: LayoutAttributesProvider,
        collectionDataSource: CollectionViewDataProvider?
    ) {
        self.layoutDataSource = layoutDataSource
        self.collectionDataSource = collectionDataSource
        
        self.insertCalculator = InsertVisibleStateCalculator()
        self.deleteCalculator = DeleteVisibleStateCalculator()
    }
    
    public func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        guard
            let collectionDataSource = collectionDataSource, enableAutomaticContentOffsetAdjustment else {
                return
        }
        
        let previousContentOffset = collectionDataSource.contentOffset
        let diff = offsetDifference(
            for: updateItems.map({ CollectionViewUpdateItem(item: $0) })
        )
        guard diff.x != 0 || diff.y != 0 else {
            return
        }
        offset = CGPoint(x: previousContentOffset.x + diff.x,
                         y: previousContentOffset.y + diff.y)
    }
    
    public func resetOffset() {
        offset = nil
    }
    
    public func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if !context.invalidateEverything {
            refreshVisibleAttributes()
        }
    }
    
    public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let offset = offset else {
            return proposedContentOffset
        }
        return offset
    }
    
    private func offsetDifference(for updates: [CollectionViewUpdateItem]) -> CGPoint {
        
        let isInitialLoading: Bool = visibleState.bottom.row == -Int.max &&
            visibleState.top.row == Int.max
        guard !isInitialLoading else {
            return .zero
        }
        
        let previousVisibleFrame = previousVisibleAttributes[visibleState.currentTargetIndexPath] ?? .zero        
        
        for item in updates {
            switch item.updateAction {
            case .insert:
                visibleState = insertCalculator.calculate(
                    for: item,
                    visibleState: visibleState
                )
            case .delete:
                visibleState = deleteCalculator.calculate(
                    for: item,
                    visibleState: visibleState
                )
            case .move, .none, .reload:
                break
            @unknown default:
                break
            }
        }
        
        let newVisibleFrame = layoutDataSource?
            .layoutAttributesForItem(at: visibleState.currentTargetIndexPath)?.frame ?? .zero
        let calculatedOffsetDiff = diff(fromPreviousFrame: previousVisibleFrame, new: newVisibleFrame)
        return calculatedOffsetDiff
    }
    
    private func refreshVisibleAttributes() {
        refreshVisibleState()
        
        guard let collectionDataSource = collectionDataSource,
              let layoutDataSource = layoutDataSource else {
            return
        }
        let visibleCache = collectionDataSource
            .indexPathsForVisibleItems
            .reduce(into: [IndexPath: CGRect](), { seed, indexPath in
                seed[indexPath] = layoutDataSource.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
            })
        previousVisibleAttributes = visibleCache
    }
    
    private func refreshVisibleState() {
        let indexPathsVisible = collectionDataSource?
            .indexPathsForVisibleItems
            .sorted(
                by: { ($0.section < $1.section) ||
                    ($0.section == $1.section && $0.row < $1.row)
                }
            ) ?? []
        if indexPathsVisible.count >= 2 {
            let last = indexPathsVisible[indexPathsVisible.count - 2]
            let first = indexPathsVisible[1]
            visibleState = VisibleIndexesState(
                bottom: last,
                top: first
            )
        } else {
            if let first = indexPathsVisible.first,
               let last = indexPathsVisible.last {
                visibleState = VisibleIndexesState(
                    bottom: last,
                    top: first
                )
            }
        }
    }
    
    private func diff(fromPreviousFrame previous: CGRect, new: CGRect) -> CGPoint {
        CGPoint(x: new.minX - previous.minX, y: new.minY - previous.minY)
    }
}
