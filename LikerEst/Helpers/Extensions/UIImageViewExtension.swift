//
//  UIImageViewExtension.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 11.11.24.
//

import UIKit

extension UIImageView {
    func configureImage() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
