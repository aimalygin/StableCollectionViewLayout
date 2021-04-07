//
//  CalculationResult.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 07.04.2021.
//

import UIKit

public struct CalculationResult {
    let beforeAttributes: [UICollectionViewLayoutAttributes]
    let afterAttributes: [UICollectionViewLayoutAttributes]
    let modifiedVisibleState: VisibleIndexesState?
    
    static var zero = CalculationResult(
        beforeAttributes: [],
        afterAttributes: [],
        modifiedVisibleState: nil
    )
    
    init(
        beforeAttributes: [UICollectionViewLayoutAttributes],
        afterAttributes: [UICollectionViewLayoutAttributes],
        modifiedVisibleState: VisibleIndexesState?
    ) {
        self.beforeAttributes = beforeAttributes
        self.afterAttributes = afterAttributes
        self.modifiedVisibleState = modifiedVisibleState
    }
    
    init(afterAttributes: [UICollectionViewLayoutAttributes],
         modifiedVisibleState: VisibleIndexesState? = nil) {
        self.init(
            beforeAttributes: [],
            afterAttributes: afterAttributes,
            modifiedVisibleState: modifiedVisibleState
        )
    }
    
    init(beforeAttributes: [UICollectionViewLayoutAttributes],
         modifiedVisibleState: VisibleIndexesState? = nil) {
        self.init(
            beforeAttributes: beforeAttributes,
            afterAttributes: [],
            modifiedVisibleState: modifiedVisibleState
        )
    }
}
