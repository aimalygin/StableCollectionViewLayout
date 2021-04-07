//
//  CollectionViewDataProvider.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 06.04.2021.
//

import Foundation

public protocol CollectionViewDataProvider: class {
    var numberOfSections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
    var indexPathsForVisibleItems: [IndexPath] { get }
}
