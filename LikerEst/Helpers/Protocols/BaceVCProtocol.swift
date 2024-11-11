//
//  BaceVCProtocol.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import Foundation

protocol BaseVCProtocol {
    // Add the subviews to the main view and sub views using this method
    func setupView()
    // Set the constraints of the layouts using this method
    func makeConstraints()
    // Set up layout attributes such as titles, images using this method
    func setupProperties()
}
