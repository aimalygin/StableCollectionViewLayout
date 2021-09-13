//
//  OffsetController.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 07.04.2021.
//

import Foundation
import UIKit

public protocol OffsetController {
    var scrollDirection: UICollectionView.ScrollDirection { get set }
    func refreshVisibleAttributes()
    func offsetDifference(for updates: [CollectionViewUpdateItem]) -> CGFloat
}
