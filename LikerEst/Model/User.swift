//
//  User.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import Foundation

struct User: Decodable {
    let id: String
    let username: String
    let name: String
    let profileImage: ProfileImage
    let location: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case profileImage = "profile_image"
        case location
    }
}
