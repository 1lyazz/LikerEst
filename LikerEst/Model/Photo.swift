//
//  Photo.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let created_at: String
    let user: User
    let urls: URLs
    let downloads: Int
    let location: Location?
}
