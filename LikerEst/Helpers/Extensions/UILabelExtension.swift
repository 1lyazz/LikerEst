//
//  UILabelExtension.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import UIKit

extension UILabel {
    func configureWith(_ text: String,
                       color: UIColor,
                       alignment: NSTextAlignment,
                       size: CGFloat,
                       weight: UIFont.Weight = .regular)
    {
        self.font = .systemFont(ofSize: size, weight: weight)
        self.text = text
        self.textColor = color
        self.textAlignment = alignment
    }
}
