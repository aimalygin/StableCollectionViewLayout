//
//  VisibleIndexesStateTests.swift
//  StableCollectionViewLayoutTests
//
//  Created by Anton Malygin on 17.10.2021.
//

@testable import StableCollectionViewLayout
import XCTest

final class VisibleIndexesStateControllerTests: XCTestCase {
    private lazy var sut = VisibleIndexesStateControllerImpl()

    func testCalculate_WhenExternalIndexPathIsNilAndVisibleIndexPathsIsEmpty_TargetIndexPathShouldBeZero() throws {
        let expectedState = VisibleIndexesState(
            targetIndexPath: .zero,
            topIndexPath: .zero,
            bottomIndexPath: .zero
        )
        sut.calculate(withIndexPathsForVisibleItems: [])

        XCTAssertNil(sut.externalTargetIndexPath)
        XCTAssertEqual(sut.state, expectedState)
    }

    func testCalculate_WhenExternalIndexPathIsNil_TargetIndexPathShouldBeFirstVisible() throws {
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)

        XCTAssertNil(sut.externalTargetIndexPath)
        XCTAssertEqual(sut.state, Env.commonExpectedState)
    }

    func testCalculate_WhenExternalIndexPathIsAllowable_TargetIndexPathShouldBeEqual() throws {
        let externalIndexPath = Env.singleSectionVisibleIndexPaths[5]
        let expectedState = VisibleIndexesState(
            targetIndexPath: externalIndexPath,
            topIndexPath: Env.singleSectionVisibleIndexPaths.first!,
            bottomIndexPath: Env.singleSectionVisibleIndexPaths.last!
        )
        sut.externalTargetIndexPath = externalIndexPath
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)

        XCTAssertEqual(sut.externalTargetIndexPath, externalIndexPath)
        XCTAssertEqual(sut.state, expectedState)
    }

    func testCalculate_WhenExternalIndexPathLessThanFirstVisible_TargetIndexPathShouldBeFirstVisible() throws {
        let externalIndexPath = IndexPath(row: 1, section: 0)

        sut.externalTargetIndexPath = externalIndexPath
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)

        XCTAssertNil(sut.externalTargetIndexPath)
        XCTAssertEqual(sut.state, Env.commonExpectedState)
    }

    func testCalculate_WhenExternalIndexPathMoreThanLastVisible_TargetIndexPathShouldBeLastVisible() throws {
        let externalIndexPath = IndexPath(row: 17, section: 0)
        let expectedState = VisibleIndexesState(
            targetIndexPath: Env.singleSectionVisibleIndexPaths.last!,
            topIndexPath: Env.singleSectionVisibleIndexPaths.first!,
            bottomIndexPath: Env.singleSectionVisibleIndexPaths.last!
        )
        sut.externalTargetIndexPath = externalIndexPath
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)

        XCTAssertNil(sut.externalTargetIndexPath)
        XCTAssertEqual(sut.state, expectedState)
    }

    func testCalculate_WhenInsertRow_StateShouldBeIncremented() throws {
        let externalIndexPath = IndexPath(row: 10, section: 0)
        let expectedState = VisibleIndexesState(
            targetIndexPath: externalIndexPath.incrementedRow(),
            topIndexPath: Env.singleSectionVisibleIndexPaths.first!.incrementedRow(),
            bottomIndexPath: Env.singleSectionVisibleIndexPaths.last!.incrementedRow()
        )
        sut.externalTargetIndexPath = externalIndexPath
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: CollectionViewUpdateItem(
            indexPathBeforeUpdate: nil,
            indexPathAfterUpdate: IndexPath(row: 0, section: 0),
            updateAction: .insert,
            isSection: false
        ))

        XCTAssertEqual(sut.state, expectedState)
    }

    func testCalculate_WhenInsertSection_StateShouldBeIncremented() throws {
        let externalIndexPath = IndexPath(row: 10, section: 0)
        let expectedState = VisibleIndexesState(
            targetIndexPath: externalIndexPath.incrementedSection(),
            topIndexPath: Env.singleSectionVisibleIndexPaths.first!.incrementedSection(),
            bottomIndexPath: Env.singleSectionVisibleIndexPaths.last!.incrementedSection()
        )
        sut.externalTargetIndexPath = externalIndexPath
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: CollectionViewUpdateItem(
            indexPathBeforeUpdate: nil,
            indexPathAfterUpdate: IndexPath(row: 0, section: 0),
            updateAction: .insert,
            isSection: true
        ))

        XCTAssertEqual(sut.state, expectedState)
    }

    func testCalculate_WhenDeleteRow_StateShouldBeDecremented() throws {
        let expectedState = VisibleIndexesState(
            targetIndexPath: Env.singleSectionVisibleIndexPaths.first!.decrementedRow(),
            topIndexPath: Env.singleSectionVisibleIndexPaths.first!.decrementedRow(),
            bottomIndexPath: Env.singleSectionVisibleIndexPaths.last!.decrementedRow()
        )
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: CollectionViewUpdateItem(
            indexPathBeforeUpdate: IndexPath(row: 0, section: 0),
            indexPathAfterUpdate: nil,
            updateAction: .delete,
            isSection: false
        ))

        XCTAssertEqual(sut.state, expectedState)
    }

    func testCalculate_WhenDeleteSection_StateShouldBeDecremented() throws {
        let expectedState = VisibleIndexesState(
            targetIndexPath: Env.singleSectionVisibleIndexPaths.first!.decrementedSection(),
            topIndexPath: Env.singleSectionVisibleIndexPaths.first!.decrementedSection(),
            bottomIndexPath: Env.singleSectionVisibleIndexPaths.last!.decrementedSection()
        )
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: CollectionViewUpdateItem(
            indexPathBeforeUpdate: IndexPath(row: 0, section: 0),
            indexPathAfterUpdate: nil,
            updateAction: .delete,
            isSection: true
        ))

        XCTAssertEqual(sut.state, expectedState)
    }

    func testCalculate_WhenReloadRow_StateShouldNotChanged() throws {
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: CollectionViewUpdateItem(
            indexPathBeforeUpdate: IndexPath(row: 0, section: 0),
            indexPathAfterUpdate: nil,
            updateAction: .reload,
            isSection: false
        ))

        XCTAssertEqual(sut.state, Env.commonExpectedState)
    }

    func testCalculate_WhenInsertRow_StateShouldNotChanged() throws {
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: CollectionViewUpdateItem(
            indexPathBeforeUpdate: IndexPath(row: 25, section: 0),
            indexPathAfterUpdate: nil,
            updateAction: .reload,
            isSection: false
        ))

        XCTAssertEqual(sut.state, Env.commonExpectedState)
    }

    func testCalculate_WhenInsertSection_StateShouldNotChanged() throws {
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: CollectionViewUpdateItem(
            indexPathBeforeUpdate: IndexPath(row: 0, section: 1),
            indexPathAfterUpdate: nil,
            updateAction: .reload,
            isSection: true
        ))

        XCTAssertEqual(sut.state, Env.commonExpectedState)
    }

    func testCalculate_WhenInsertWithIncorrectedUpdateItem_StateShouldNotChanged() throws {
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: Env.incorrectInsertItem)

        XCTAssertEqual(sut.state, Env.commonExpectedState)
    }

    func testCalculate_WhenDeleteWithIncorrectedUpdateItem_StateShouldNotChanged() throws {
        sut.calculate(withIndexPathsForVisibleItems: Env.singleSectionVisibleIndexPaths)
        sut.update(with: Env.incorrectDeleteItem)

        XCTAssertEqual(sut.state, Env.commonExpectedState)
    }
}

private enum Env {
    static let singleSectionVisibleIndexPaths = (5 ..< 15).map { IndexPath(row: $0, section: 0) }
    static let commonExpectedState = VisibleIndexesState(
        targetIndexPath: Env.singleSectionVisibleIndexPaths.first!,
        topIndexPath: Env.singleSectionVisibleIndexPaths.first!,
        bottomIndexPath: Env.singleSectionVisibleIndexPaths.last!
    )

    static let incorrectInsertItem = CollectionViewUpdateItem(
        indexPathBeforeUpdate: nil,
        indexPathAfterUpdate: nil,
        updateAction: .insert,
        isSection: false
    )

    static let incorrectDeleteItem = CollectionViewUpdateItem(
        indexPathBeforeUpdate: nil,
        indexPathAfterUpdate: nil,
        updateAction: .delete,
        isSection: false
    )
}
