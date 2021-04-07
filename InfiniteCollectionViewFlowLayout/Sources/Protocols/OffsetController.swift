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
    var minimumLineSpacing: CGFloat { get set }
    var minimumInteritemSpacing: CGFloat { get set }
    
    var isLayoutAttributeEmpty: Bool { get }
    
    func refreshAttributes()
    func calculateOffsetDiff(for updates: [CollectionViewUpdateItem]) -> CGFloat
}
