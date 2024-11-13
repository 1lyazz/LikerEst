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

    static func showAlertForPhotoAccess(presentingViewController: UIViewController) {
        let alert = UIAlertController(title: "Oops!", message: "To save photos, you'll need to allow Photos access in Settings", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        settingsAction.setValue(UIColor.label, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.label, forKey: "titleTextColor")
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        presentingViewController.present(alert, animated: true, completion: nil)
    }
}
