//
//  Photo.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let altDescription: String?
    let urls: PhotoURLs
    let user: User
    let likes: Int
    let width: Int
    let height: Int
    let createdAt: String
    let location: Location?
    let downloads: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case altDescription = "alt_description"
        case urls
        case user
        case likes
        case width
        case height
        case createdAt = "created_at"
        case location
        case downloads
    }
}
