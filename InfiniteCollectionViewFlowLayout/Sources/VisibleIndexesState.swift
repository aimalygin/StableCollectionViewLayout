//
//  VisibleIndexesState.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 06.04.2021.
//

import Foundation

public struct VisibleIndexesState {
    enum TargetIndexType {
        case top
        case bottom
    }
    
    var targetIndexType: TargetIndexType = .top
    var targetIndexPath: IndexPath? = nil
        
    let bottom: IndexPath
    let top: IndexPath
    
    init(bottom: IndexPath = IndexPath(row: -Int.max, section: -Int.max),
         top: IndexPath = IndexPath(row: Int.max, section: Int.max),
         targetIndexPath: IndexPath? = nil) {
        self.bottom = bottom
        self.top = top
        self.targetIndexPath = targetIndexPath
    }
    
    var currentTargetIndexPath: IndexPath {
        guard targetIndexPathIsVisible,
              let indexPath = targetIndexPath,
              targetIndexType == .bottom else {
            return targetIndexPathDependsOnType
        }
        return indexPath
    }
    
    func incrementedRows() -> VisibleIndexesState {
        let indexPath = currentTargetIndexPath
        var bottomIndexPath = bottom
        if bottom == indexPath {
            bottomIndexPath = IndexPath(row: bottom.row + 1, section: bottom.section)
        }
        var topIndexPath = top
        if top == indexPath {
            topIndexPath = IndexPath(row: top.row + 1, section: top.section)
        }
        var targetIndexPath = self.targetIndexPath
        if let targetIndex = targetIndexPath,
            targetIndex == indexPath {
            targetIndexPath = IndexPath(row: targetIndex.row + 1, section: targetIndex.section)
        }
        return VisibleIndexesState(bottom: bottomIndexPath, top: topIndexPath, targetIndexPath: targetIndexPath)
    }
    
    func incrementedSections() -> VisibleIndexesState {
        let indexPath = currentTargetIndexPath
        var bottomIndexPath = bottom
        if bottom.section <= indexPath.section {
            bottomIndexPath = IndexPath(row: bottom.row, section: bottom.section + 1)
        }
        var topIndexPath = top
        if top.section <= indexPath.section {
            topIndexPath = IndexPath(row: top.row, section: top.section + 1)
        }
        
        var targetIndexPath = self.targetIndexPath
        if let targetIndex = targetIndexPath, targetIndex.section <= indexPath.section {
            targetIndexPath = IndexPath(row: targetIndex.row, section: targetIndex.section + 1)
        }
        return VisibleIndexesState(bottom: bottomIndexPath, top: topIndexPath, targetIndexPath: targetIndexPath)
    }
    
    func decrementedRows() -> VisibleIndexesState {
        let indexPath = currentTargetIndexPath
        var bottomIndexPath = bottom
        if bottom == indexPath {
            bottomIndexPath = IndexPath(row: bottom.row - 1, section: bottom.section)
        }
        var topIndexPath = top
        if top == indexPath {
            topIndexPath = IndexPath(row: top.row - 1, section: top.section)
        }
        var targetIndexPath = self.targetIndexPath
        if let targetIndex = targetIndexPath,
            targetIndex == indexPath {
            targetIndexPath = IndexPath(row: targetIndex.row - 1, section: targetIndex.section)
        }
        return VisibleIndexesState(bottom: bottomIndexPath, top: topIndexPath, targetIndexPath: targetIndexPath)
    }
    
    func decrementedSections() -> VisibleIndexesState {
        let indexPath = currentTargetIndexPath
        var bottomIndexPath = bottom
        if bottom.section <= indexPath.section {
            bottomIndexPath = IndexPath(row: bottom.row, section: bottom.section - 1)
        }
        var topIndexPath = top
        if top.section <= indexPath.section {
            topIndexPath = IndexPath(row: top.row, section: top.section - 1)
        }
        
        var targetIndexPath = self.targetIndexPath
        if let targetIndex = targetIndexPath, targetIndex.section <= indexPath.section {
            targetIndexPath = IndexPath(row: targetIndex.row, section: targetIndex.section - 1)
        }
        return VisibleIndexesState(bottom: bottomIndexPath, top: topIndexPath, targetIndexPath: targetIndexPath)
    }
    
    private var targetIndexPathIsVisible: Bool {
        guard let target = targetIndexPath else { return false }
        return target <= bottom && target >= top
    }
    
    private var targetIndexPathDependsOnType: IndexPath {
        if targetIndexType == .top {
            return top
        } else {
            return bottom
        }
    }
}
