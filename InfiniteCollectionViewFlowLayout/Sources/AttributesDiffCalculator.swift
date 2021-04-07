//
//  AttributesDiffCalculator.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 07.04.2021.
//

import UIKit

struct AttributesDiffCalculator {
    let itemSpacing: CGFloat
    let scrollDirection: UICollectionView.ScrollDirection
    
    func calculateDiff(from attributesArray: [UICollectionViewLayoutAttributes]) -> CGFloat {
        let fullRect = attributesArray
            .reduce(CGRect.zero) { (unionRect, attributes) -> CGRect in
                unionRect.union(attributes.frame)
            }
        return calculateDiff(
            for: fullRect,
            itemsCount: attributesArray.count
        )
    }
    
    func calculateReloadDiff(
        beforeAttributes: [UICollectionViewLayoutAttributes],
        afterAttributes: [UICollectionViewLayoutAttributes]
    ) -> CGFloat {
        let fullBeforeRect = beforeAttributes
            .reduce(CGRect.zero) { (unionRect, attributes) -> CGRect in
                unionRect.union(attributes.frame)
            }
        let fullAfterRect = afterAttributes
            .reduce(CGRect.zero) { (unionRect, attributes) -> CGRect in
                unionRect.union(attributes.frame)
            }
        return fullAfterRect.intersection(fullBeforeRect)
            .maxSizeBy(scrollDirection)
    }
    
    private func calculateDiff(for rect: CGRect, itemsCount: Int) -> CGFloat {
        rect.maxSizeBy(scrollDirection) + (itemsCount > 0 ? itemSpacing : 0)
    }
}

fileprivate extension CGRect {
    func maxSizeBy(_ scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        scrollDirection == .vertical ? maxY : maxX
    }
}
