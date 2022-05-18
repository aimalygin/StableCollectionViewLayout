//
//  CollectionViewUpdateItemTests.swift
//  StableCollectionViewLayoutTests
//
//  Created by Anton Malygin on 17.10.2021.
//

@testable import StableCollectionViewLayout
import XCTest

class CollectionViewUpdateItemTests: XCTestCase {
    func testInitRowItem() throws {
        let expectedItem = CollectionViewUpdateItem(
            indexPathBeforeUpdate: nil,
            indexPathAfterUpdate: .zero,
            updateAction: .insert,
            isSection: false
        )
        let sut = CollectionViewUpdateItem(
            indexPathBeforeUpdate: expectedItem.indexPathBeforeUpdate,
            indexPathAfterUpdate: expectedItem.indexPathAfterUpdate,
            updateAction: expectedItem.updateAction
        )

        XCTAssertEqual(expectedItem, sut)
    }

    func testInitSectionItem() throws {
        let expectedItem = CollectionViewUpdateItem(
            indexPathBeforeUpdate: nil,
            indexPathAfterUpdate: IndexPath(row: Int.max, section: 0),
            updateAction: .insert,
            isSection: true
        )
        let sut = CollectionViewUpdateItem(
            indexPathBeforeUpdate: expectedItem.indexPathBeforeUpdate,
            indexPathAfterUpdate: expectedItem.indexPathAfterUpdate,
            updateAction: expectedItem.updateAction
        )

        XCTAssertEqual(expectedItem, sut)
    }
}
