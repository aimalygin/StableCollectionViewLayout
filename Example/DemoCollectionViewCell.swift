//
//  DemoCollectionViewCell.swift
//  Example
//
//  Created by Anton Malygin on 17.02.2021.
//

import Foundation
import UIKit

class DemoCollectionViewCell: UICollectionViewCell {
    let textLabel: UILabel = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        textLabel.text = nil
    }

    private func setup() {
        backgroundColor = UIColor(red: 93 / 255, green: 173 / 255, blue: 2 / 255, alpha: 1)

        setupLabel()
    }

    private func setupLabel() {
        contentView.addSubview(textLabel)
        textLabel.font = .systemFont(ofSize: 35)
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        textLabel.frame = layoutAttributes.bounds
    }
}
