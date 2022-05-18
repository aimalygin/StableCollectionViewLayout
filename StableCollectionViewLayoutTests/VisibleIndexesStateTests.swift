//
//  VisibleIndexesStateTests.swift
//  StableCollectionViewLayoutTests
//
//  Created by Anton Malygin on 17.10.2021.
//

@testable import StableCollectionViewLayout
import XCTest

final class VisibleIndexesStateTests: XCTestCase {
    lazy var sut = VisibleIndexesState(
        targetIndexPath: IndexPath(row: 5, section: 0),
        topIndexPath: IndexPath(row: 5, section: 0),
        bottomIndexPath: IndexPath(row: 10, section: 0)
    )

    func testInsertRow_WhenStateShouldNotIncremented() throws {
        XCTAssertEqual(sut, sut.insertedRow(at: IndexPath(row: 15, section: 0)))
    }

    func testInsertSection_WhenStateShouldNotIncremented() throws {
        XCTAssertEqual(sut, sut.insertedSection(at: IndexPath(row: 0, section: 1)))
    }

    func testDeleteRow_WhenStateShouldNotIncremented() throws {
        XCTAssertEqual(sut, sut.deletedRow(at: IndexPath(row: 15, section: 0)))
    }

    func testDeleteSection_WhenStateShouldNotIncremented() throws {
        XCTAssertEqual(sut, sut.deletedSection(at: IndexPath(row: 0, section: 1)))
    }

    func testInsertRow_WhenStateShouldBeIncremented() throws {
        let expectedState = VisibleIndexesState(
            targetIndexPath: sut.targetIndexPath.incrementedRow(),
            topIndexPath: sut.topIndexPath.incrementedRow(),
            bottomIndexPath: sut.bottomIndexPath.incrementedRow()
        )

        let result = sut.insertedRow(at: IndexPath(row: 1, section: 0))

        XCTAssertEqual(result, expectedState)
    }

    func testInsertSection_WhenStateShouldBeIncremented() throws {
        let expectedState = VisibleIndexesState(
            targetIndexPath: sut.targetIndexPath.incrementedSection(),
            topIndexPath: sut.topIndexPath.incrementedSection(),
            bottomIndexPath: sut.bottomIndexPath.incrementedSection()
        )

        let result = sut.insertedSection(at: IndexPath(row: 1, section: 0))

        XCTAssertEqual(result, expectedState)
    }
}
