//
//  Optional+Extension.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 01.04.2021.
//

import Foundation

extension Optional {
    func withWrapped(_ closure: (Wrapped) throws -> Void) rethrows {
        guard case let .some(value) = self else {
            return
        }
        try closure(value)
    }
}
