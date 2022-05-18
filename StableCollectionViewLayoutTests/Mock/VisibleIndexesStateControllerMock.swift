//
//  VisibleIndexesStateControllerMock.swift
//  StableCollectionViewLayoutTests
//
//  Created by Anton Malygin on 17.10.2021.
//

import Foundation
@testable import StableCollectionViewLayout

class VisibleIndexesStateControllerMock: VisibleIndexesStateController {
    var state: VisibleIndexesState = .init()

    func calculate(withIndexPathsForVisibleItems _: [IndexPath]) {}

    func update(with _: CollectionViewUpdateItem) {}
}
