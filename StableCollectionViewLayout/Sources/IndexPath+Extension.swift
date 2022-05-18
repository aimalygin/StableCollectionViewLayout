//
//  IndexPath+Extension.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 17.10.2021.
//

import Foundation

extension IndexPath {
    static var zero: IndexPath {
        IndexPath(row: 0, section: 0)
    }

    func insertedRow(at indexPath: IndexPath) -> IndexPath {
        if indexPath.section == section,
           indexPath.row <= row
        {
            return incrementedRow()
        }
        return self
    }

    func insertedSection(at indexPath: IndexPath) -> IndexPath {
        if indexPath.section <= section {
            return incrementedSection()
        }
        return self
    }

    func deletedRow(at indexPath: IndexPath) -> IndexPath {
        if indexPath.section == section,
           indexPath.row <= row
        {
            return decrementedRow()
        }
        return self
    }

    func deletedSection(at indexPath: IndexPath) -> IndexPath {
        if indexPath.section <= section {
            return decrementedSection()
        }
        return self
    }

    func incrementedRow() -> IndexPath {
        IndexPath(row: row + 1, section: section)
    }

    func incrementedSection() -> IndexPath {
        IndexPath(row: row, section: section + 1)
    }

    func decrementedRow() -> IndexPath {
        IndexPath(row: row - 1, section: section)
    }

    func decrementedSection() -> IndexPath {
        IndexPath(row: row, section: section - 1)
    }
}
