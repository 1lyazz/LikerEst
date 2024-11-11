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

    static func createSaveImageAlert(error: Error?) -> UIAlertController {
        let alert: UIAlertController
        if let error = error {
            alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Saved", message: "\nYour image has been saved to your Photos", preferredStyle: .alert)
        }

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor.label, forKey: "titleTextColor")
        alert.addAction(okAction)

        return alert
    }
}
