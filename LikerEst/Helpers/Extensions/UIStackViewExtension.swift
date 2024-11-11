//
//  UIStackViewExtension.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }

    func configureStackView(axis: NSLayoutConstraint.Axis = .horizontal,
                            alignment: UIStackView.Alignment = .center,
                            distribution: UIStackView.Distribution = .equalSpacing,
                            spacing: CGFloat = 10,
                            backgroundColor: UIColor = .systemGray3,
                            cornerRadius: CGFloat = 22,
                            layoutMargins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        self.tintColor = .label
        self.backgroundColor = backgroundColor
        self.setupCornerRadius(cornerRadius)
        self.layoutMargins = layoutMargins
        self.isLayoutMarginsRelativeArrangement = true
    }
}
