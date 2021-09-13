//
//  OffsetCalculator.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

public class OffsetControllerImpl: OffsetController {
    private weak var layoutDataSource: LayoutAttributesProvider?
    private weak var collectionDataSource: CollectionViewDataProvider?
    
    private var visibleState = VisibleIndexesState()
    
    private let insertCalculator: InsertVisibleStateCalculator
    private let deleteCalculator: DeleteVisibleStateCalculator
    
    public var scrollDirection: UICollectionView.ScrollDirection
    public var previousVisibleAttributes: [IndexPath: CGRect] = [:]
    
    init(
        layoutDataSource: LayoutAttributesProvider,
        collectionDataSource: CollectionViewDataProvider?,
        scrollDirection: UICollectionView.ScrollDirection
    ) {
        self.layoutDataSource = layoutDataSource
        self.collectionDataSource = collectionDataSource
        self.scrollDirection = scrollDirection
        
        self.insertCalculator = InsertVisibleStateCalculator()
        self.deleteCalculator = DeleteVisibleStateCalculator()
    }
    
    public func refreshVisibleAttributes() {
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
    
    public func offsetDifference(for updates: [CollectionViewUpdateItem]) -> CGFloat {
        
        let isInitialLoading: Bool = visibleState.bottom.row == -Int.max &&
            visibleState.top.row == Int.max
        guard !isInitialLoading else {
            return 0
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
    
    private func diff(fromPreviousFrame previous: CGRect, new: CGRect) -> CGFloat {
        scrollDirection == .vertical ? new.minY - previous.minY : new.minX - previous.minX
    }
}

