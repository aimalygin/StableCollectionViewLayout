//
//  VisibleIndexesState.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 06.04.2021.
//

import Foundation

struct VisibleIndexesState: Equatable {
    let targetIndexPath: IndexPath
    let topIndexPath: IndexPath
    let bottomIndexPath: IndexPath
    
    init(
        targetIndexPath: IndexPath = .zero,
        topIndexPath: IndexPath = .zero,
        bottomIndexPath: IndexPath = .zero
    ) {
        self.targetIndexPath = targetIndexPath
        self.topIndexPath = topIndexPath
        self.bottomIndexPath = bottomIndexPath
    }

    func insertedRow(at indexPath: IndexPath) -> VisibleIndexesState {
        VisibleIndexesState(
            targetIndexPath: targetIndexPath.insertedRow(at: indexPath),
            topIndexPath: topIndexPath.insertedRow(at: indexPath),
            bottomIndexPath: bottomIndexPath.insertedRow(at: indexPath)
        )
    }
    
    func insertedSection(at indexPath: IndexPath) -> VisibleIndexesState {
        VisibleIndexesState(
            targetIndexPath: targetIndexPath.insertedSection(at: indexPath),
            topIndexPath: topIndexPath.insertedSection(at: indexPath),
            bottomIndexPath: bottomIndexPath.insertedSection(at: indexPath)
        )
    }
    
    func deletedRow(at indexPath: IndexPath) -> VisibleIndexesState {
        VisibleIndexesState(
            targetIndexPath: targetIndexPath.deletedRow(at: indexPath),
            topIndexPath: topIndexPath.deletedRow(at: indexPath),
            bottomIndexPath: bottomIndexPath.deletedRow(at: indexPath)
        )
    }
    
    func deletedSection(at indexPath: IndexPath) -> VisibleIndexesState {
        VisibleIndexesState(
            targetIndexPath: targetIndexPath.deletedSection(at: indexPath),
            topIndexPath: topIndexPath.deletedSection(at: indexPath),
            bottomIndexPath: bottomIndexPath.deletedSection(at: indexPath)
        )
    }
}
