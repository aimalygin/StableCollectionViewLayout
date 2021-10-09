//
//  DataGenerator.swift
//  InfiniteCollectionViewFlowLayoutTests
//
//  Created by Anton Malygin on 09.04.2021.
//

import Foundation
import UIKit

typealias Cache = [IndexPath: UICollectionViewLayoutAttributes]
class DataGenerator {
    
    static func generateAttributes(
        maxCountByRow: Int,
        rowsCount: Int,
        rowSpacing: CGFloat,
        scrollDirection: UICollectionView.ScrollDirection,
        size: (_ numberInRow: Int, _ indexPath: IndexPath) -> CGSize
    ) -> Cache {
        let indexPaths = (0..<rowsCount).map({ IndexPath(row: $0, section: 0) })
        var cache = [IndexPath: UICollectionViewLayoutAttributes]()
        var numberInRow = 0
        var originY = scrollDirection == .vertical ? rowSpacing : CGFloat(0)
        var originX = scrollDirection == .horizontal ? rowSpacing : CGFloat(0)
        var maxSizeElementOfRow = CGFloat(0)
        for indexPath in indexPaths {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            if numberInRow >= maxCountByRow {
                numberInRow = 0
                if scrollDirection == .vertical {
                    originY += rowSpacing + maxSizeElementOfRow
                    originX = 0
                } else {
                    originX += rowSpacing + maxSizeElementOfRow
                    originY = 0
                }
                maxSizeElementOfRow = 0
            }
            let size = size(numberInRow, indexPath)
            attributes.frame = CGRect(x: originX, y: originY, width: size.width, height: size.height)
            if scrollDirection == .vertical {
                maxSizeElementOfRow = max(maxSizeElementOfRow, size.height)
                originX += size.width
            } else {
                maxSizeElementOfRow = max(maxSizeElementOfRow, size.width)
                originY += size.height
            }
            numberInRow += 1
            cache[indexPath] = attributes
        }
        return cache
    }
}
