//
//  UIAlertCExtension.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 10.11.24.
//

import UIKit

extension UIAlertController {
    static func createDetailsAlert(photo: Photo) -> UIAlertController {
        let message = """
        Likes: \(photo.likes)
        Size: \(photo.width)x\(photo.height)
        Downloads: \(photo.downloads ?? 0)
        Description: \(photo.altDescription ?? "meow")
        """
        let alert = UIAlertController(title: "Details", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor.label, forKey: "titleTextColor")

        alert.addAction(okAction)

        return alert
    }
}
