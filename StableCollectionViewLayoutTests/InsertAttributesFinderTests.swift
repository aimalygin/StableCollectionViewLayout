//
//  InsertAttributesFinderTests.swift
//  InfiniteCollectionViewFlowLayoutTests
//
//  Created by Anton Malygin on 08.04.2021.
//

import XCTest
@testable import InfiniteCollectionViewFlowLayout

class InsertAttributesFinderTests: XCTestCase {
    
    private var cachedAttributesProvider = LayoutAttributesCache()
    private var layoutAttributesProvider = LayoutAttributesProviderMock()
    private var collectionViewDataProvider = CollectionViewDataProviderMock()
    
    private lazy var sut = InsertAttributesFinder(
        layoutDataSource: layoutAttributesProvider,
        collectionDataSource: collectionViewDataProvider,
        cachedLayoutAttributeProvider: cachedAttributesProvider
    )

    func test_WhenInsertOneItemToRowContainingThreeElements_CalculationResultShouldBeDefined() throws {
        let rowSpacing = CGFloat(10)
        let generatedCache = completeDataCachedAttributesProvider(rowSpacing: rowSpacing)
        
        let bottom = IndexPath(row: 5, section: 0)
        let top = IndexPath(row: 3, section: 0)
        let visible = VisibleIndexesState(bottom: bottom, top: top, targetIndexPath: nil)
        
        let insertedIndexPath = IndexPath(row: 0, section: 0)
        let update = CollectionViewUpdateItem(
            indexPathBeforeUpdate: nil,
            indexPathAfterUpdate: insertedIndexPath,
            updateAction: .insert,
            isSection: false
        )
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: insertedIndexPath)
        attributes.frame = CGRect(x: 0, y: rowSpacing, width: 100, height: 200)
        
        completeAttributesAfterInsert(
            rowSpacing: rowSpacing,
            cache: generatedCache,
            insertLayoutAttributes: attributes
        )
        
        let result = sut.suitableLayoutAttributes(update, visibleState: visible)
        let referenceVisibleState = VisibleIndexesState(
            bottom: bottom,
            top: IndexPath(row: top.row + 1, section: top.section),
            targetIndexPath: nil
        )
        
        XCTAssertEqual(result.afterAttributes.count, 1)
        XCTAssertTrue(result.beforeAttributes.isEmpty)
        XCTAssertNotNil(result.afterAttributes.first)
        XCTAssertEqual(result.afterAttributes.first!.frame, attributes.frame)
        XCTAssertEqual(result.modifiedVisibleState!, referenceVisibleState)
    }
    
    private func completeDataCachedAttributesProvider(rowSpacing: CGFloat) -> Cache {
        let generated = DataGenerator.generateAttributes(
            maxCountByRow: 3,
            rowsCount: 6,
            rowSpacing: rowSpacing,
            scrollDirection: .vertical,
            size: { numberOfRow, _ in
                if numberOfRow == 1 {
                    return CGSize(width: 100, height: 150)
                }
                return CGSize(width: 100, height: 100)
            }
        )
        cachedAttributesProvider.cache = generated
        return generated
    }
    
    private func completeAttributesAfterInsert(
        rowSpacing: CGFloat,
        cache: Cache,
        insertLayoutAttributes: UICollectionViewLayoutAttributes) {
        let insertedAttributes = DataGenerator.generateAttributes(
            maxCountByRow: 3,
            rowsCount: 7,
            rowSpacing: rowSpacing,
            scrollDirection: .vertical,
            size: { _, indexPath in
                if indexPath.row == 0 {
                    return insertLayoutAttributes.frame.size
                }
                let value = cache[IndexPath(row: indexPath.row - 1, section: indexPath.section)]
                return value?.frame.size ?? .zero
            }
        )
        layoutAttributesProvider.attributes = insertedAttributes
    }
}
