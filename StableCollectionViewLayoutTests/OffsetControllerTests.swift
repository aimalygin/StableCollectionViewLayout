//
//  OffsetControllerTests.swift
//  StableCollectionViewLayoutTests
//
//  Created by Anton Malygin on 17.10.2021.
//

@testable import StableCollectionViewLayout
import XCTest

final class OffsetControllerTests: XCTestCase {
    private let layoutAttribute = LayoutAttributesProviderMock()
    private let collectionViewDataProvider = CollectionViewDataProviderMock(
        indexPathsForVisibleItems: [IndexPath(row: 0, section: 0)]
    )
    private let visibleStateController = VisibleIndexesStateControllerMock()

    private lazy var sut = OffsetControllerImpl(
        visibleStateController: visibleStateController,
        layoutDataSource: layoutAttribute,
        collectionDataSource: collectionViewDataProvider
    )

    func testTargetContentOffset_WhenNothingIsNotChanged() throws {
        visibleStateController.state = Env.visibleState
        layoutAttribute.attributes = [Env.visibleState.targetIndexPath:
            Env.sourceVisibleAtrributes]

        sut.refreshVisibleAttributes()
        sut.prepare(forCollectionViewUpdates: [CollectionViewUpdateItem.empty()])

        let result = sut.targetContentOffset(forProposedContentOffset: CGPoint.zero)
        XCTAssertNil(result)
    }

    func testTargetContentOffset_WhenDifferenceExists() throws {
        visibleStateController.state = Env.visibleState
        layoutAttribute.attributes = [Env.visibleState.targetIndexPath:
            Env.sourceVisibleAtrributes]

        sut.refreshVisibleAttributes()
        layoutAttribute.attributes = [Env.visibleState.targetIndexPath:
            Env.targetVisibleAtrributes]

        collectionViewDataProvider.numberOfSections = 1
        collectionViewDataProvider.numberOfItemsInSection = Env.visibleState.targetIndexPath.row + 1

        sut.prepare(forCollectionViewUpdates: [CollectionViewUpdateItem.empty()])

        let result = sut.targetContentOffset(forProposedContentOffset: CGPoint.zero)!
        let expected = Env.targetVisibleAtrributes.frame.minY - Env.sourceVisibleAtrributes.frame.minY
        XCTAssertEqual(result, CGPoint(x: 0, y: expected))
    }

    func testTargetContentOffset_WhenEnableAutomaticContentOffsetAdjustmentIsFalse() throws {
        visibleStateController.state = Env.visibleState
        layoutAttribute.attributes = [Env.visibleState.targetIndexPath:
            Env.sourceVisibleAtrributes]

        sut.refreshVisibleAttributes()
        layoutAttribute.attributes = [Env.visibleState.targetIndexPath:
            Env.targetVisibleAtrributes]
        sut.enableAutomaticContentOffsetAdjustment = false
        sut.prepare(forCollectionViewUpdates: [CollectionViewUpdateItem.empty()])

        let result = sut.targetContentOffset(forProposedContentOffset: CGPoint.zero)
        XCTAssertNil(result)
    }

    func testTargetContentOffset_WhenIsInitialLoading() throws {
        visibleStateController.state = Env.initialVisibleState
        layoutAttribute.attributes = [Env.initialVisibleState.targetIndexPath:
            Env.sourceVisibleAtrributes]

        sut.refreshVisibleAttributes()
        layoutAttribute.attributes = [Env.initialVisibleState.targetIndexPath:
            Env.targetVisibleAtrributes]
        sut.prepare(forCollectionViewUpdates: [CollectionViewUpdateItem.empty()])

        let result = sut.targetContentOffset(forProposedContentOffset: CGPoint.zero)
        XCTAssertNil(result)
    }
}

extension CollectionViewUpdateItem {
    static func empty() -> CollectionViewUpdateItem {
        CollectionViewUpdateItem(
            indexPathBeforeUpdate: nil,
            indexPathAfterUpdate: nil,
            updateAction: .insert,
            isSection: false
        )
    }
}

private enum Env {
    static let visibleState = VisibleIndexesState(
        targetIndexPath: IndexPath(row: 10, section: 0),
        topIndexPath: IndexPath(row: 10, section: 0),
        bottomIndexPath: IndexPath(row: 20, section: 0)
    )

    static let initialVisibleState = VisibleIndexesState(
        targetIndexPath: .zero,
        topIndexPath: IndexPath(row: Int.max, section: 0),
        bottomIndexPath: IndexPath(row: -Int.max, section: 0)
    )

    static var sourceVisibleAtrributes: UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: .zero)
        attributes.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        return attributes
    }

    static var targetVisibleAtrributes: UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: .zero)
        attributes.frame = CGRect(x: 0, y: 200, width: 100, height: 100)
        return attributes
    }
}
