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
}
