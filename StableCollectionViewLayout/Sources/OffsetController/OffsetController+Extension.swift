//
//  OffsetController+Extension.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 30.11.2021.
//

import UIKit

extension OffsetController {
    func finalizeUpdatesWithAdjustContetnOffset(_ collectionView: UICollectionView?) {
        guard let collectionView = collectionView else {
            return
        }
        if let newContentOffset = targetContentOffset(
            forProposedContentOffset: collectionView.contentOffset
        ) {
            collectionView.contentOffset = newContentOffset
        }
    }
}
