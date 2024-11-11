//
//  PhotoCoreDataService.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 10.11.24.
//

import CoreData
import UIKit

final class PhotoCoreDataService {
    static let shared = PhotoCoreDataService()
    
    // Saves photo to Core Data
    func savePhoto(_ photo: Photo) {
        let context = CoreDataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "SavedPhoto", in: context)!
        let savedPhoto = NSManagedObject(entity: entity, insertInto: context)
        
        savedPhoto.setValue(photo.id, forKey: "id")
        savedPhoto.setValue(photo.altDescription, forKey: "altDescription")
        savedPhoto.setValue(photo.urls.full, forKey: "url")
        savedPhoto.setValue(photo.urls.thumb, forKey: "thumbUrl")
        savedPhoto.setValue(photo.user.name, forKey: "username")
        savedPhoto.setValue(photo.likes, forKey: "likes")
        savedPhoto.setValue(photo.width, forKey: "width")
        savedPhoto.setValue(photo.height, forKey: "height")
        savedPhoto.setValue(photo.createdAt, forKey: "createdAt")
        savedPhoto.setValue(photo.location?.city, forKey: "city")
        savedPhoto.setValue(photo.location?.country, forKey: "country")
        savedPhoto.setValue(photo.downloads, forKey: "downloads")

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Delete photo from Core Data
    func removePhoto(_ photo: Photo) {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedPhoto")
        fetchRequest.predicate = NSPredicate(format: "id = %@", photo.id)
        
        do {
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject], let objectToDelete = result.first {
                context.delete(objectToDelete)
                try context.save()
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    // Checks if the photo is saved in Core Data
    func isPhotoLiked(_ photo: Photo) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedPhoto")
        fetchRequest.predicate = NSPredicate(format: "id = %@", photo.id)
        
        do {
            let result = try context.fetch(fetchRequest) as? [NSManagedObject]
            return result?.first != nil
        } catch {
            print("Error checking if photo is liked: \(error)")
            return false
        }
    }
}
