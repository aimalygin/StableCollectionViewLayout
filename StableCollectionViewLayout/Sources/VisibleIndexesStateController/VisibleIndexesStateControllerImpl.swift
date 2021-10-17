//
//  VisibleIndexesStateController.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 17.10.2021.
//

import Foundation

class VisibleIndexesStateControllerImpl: VisibleIndexesStateController {
    var externalTargetIndexPath: IndexPath?
    
    private(set) var state: VisibleIndexesState = VisibleIndexesState()
    
    func calculate(withIndexPathsForVisibleItems indexPaths: [IndexPath]) {
        calculate(
            with: externalTargetIndexPath,
            indexPathsForVisibleItems: indexPaths
        )
    }

    private func calculate(
        with indexPath: IndexPath?,
        indexPathsForVisibleItems: [IndexPath]
    ) {
        let visibleIndexes = indexPathsForVisibleItems.sorted(by: {
            ($0.section < $1.section) ||
                ($0.section == $1.section && $0.row < $1.row)
        })

        let topIndexPath = visibleIndexes.first ?? .zero
        let bottomIndexPath = visibleIndexes.last ?? .zero

        guard let indexPath = indexPath else {
            state = VisibleIndexesState(
                targetIndexPath: topIndexPath,
                topIndexPath: topIndexPath,
                bottomIndexPath: bottomIndexPath
            )
            return
        }

        if visibleIndexes.contains(indexPath) {
            state = VisibleIndexesState(
                targetIndexPath: indexPath,
                topIndexPath: topIndexPath,
                bottomIndexPath: bottomIndexPath
            )
        } else if let firstIndex = visibleIndexes.first, indexPath < firstIndex {
            state = VisibleIndexesState(
                targetIndexPath: firstIndex,
                topIndexPath: topIndexPath,
                bottomIndexPath: bottomIndexPath
            )
            externalTargetIndexPath = nil
        } else if let lastIndex = visibleIndexes.last {
            state = VisibleIndexesState(
                targetIndexPath: lastIndex,
                topIndexPath: topIndexPath,
                bottomIndexPath: bottomIndexPath
            )
            externalTargetIndexPath = nil
        } else {
            state = VisibleIndexesState(
                targetIndexPath: .zero,
                topIndexPath: topIndexPath,
                bottomIndexPath: bottomIndexPath
            )
            externalTargetIndexPath = nil
        }
    }
}

extension VisibleIndexesStateControllerImpl {
    func update(with item: CollectionViewUpdateItem) {
        switch item.updateAction {
        case .insert:
            state = inserted(with: item)
        case .delete:
            state = deleted(with: item)
        case .move, .none, .reload:
            break
        @unknown default:
            break
        }
    }
    
    private func inserted(with item: CollectionViewUpdateItem) -> VisibleIndexesState {
        guard let indexPath = item.indexPathAfterUpdate else {
            return state
        }
        
        if item.isSection {
            return state.insertedSection(at: indexPath)
        }
        
        return state.insertedRow(at: indexPath)
    }
    
    private func deleted(with item: CollectionViewUpdateItem) -> VisibleIndexesState {
        guard let indexPath = item.indexPathBeforeUpdate else {
            return state
        }
        
        if item.isSection {
            return state.deletedSection(at: indexPath)
        }
        
        return state.deletedRow(at: indexPath)
    }
}
