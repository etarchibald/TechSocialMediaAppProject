//
//  UserProfile.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/29/24.
//

import Foundation

struct UserProfile: Codable {
    var firstName: String
    var lastName: String
    var userName: String
    var userUUID: UUID
    var bio: String
    var techInterests: String
    var posts: [Post]
    
    enum CodingKeys: CodingKey {
        case firstName
        case lastName
        case userName
        case userUUID
        case bio
        case techInterests
        case posts
    }
}
