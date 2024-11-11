//
//  SavedPhotoExtension.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 11.11.24.
//

import UIKit

extension SavedPhoto {
    func toPhoto() -> Photo {
        return Photo(
            id: id ?? "",
            altDescription: altDescription,
            urls: PhotoURLs(thumb: thumbUrl ?? "", full: url ?? ""),
            user: User(id: "", username: "", name: username ?? "", profileImage: ProfileImage(small: "", medium: "", large: ""), location: ""),
            likes: Int(likes),
            width: Int(width),
            height: Int(height),
            createdAt: createdAt ?? "",
            location: Location(city: city, country: country),
            downloads: Int(downloads)
        )
    }
}
