//
//  CollectionViewDataProvider.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 06.04.2021.
//

import Foundation
import CoreGraphics

public protocol CollectionViewDataProvider: AnyObject {
    var numberOfSections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
    var indexPathsForVisibleItems: [IndexPath] { get }
    
    var contentOffset: CGPoint { get }
}
