//
//  PostProfile.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/2/24.
//

import Foundation

struct PostProfile {
    var userName: String
    var bio: String
    var techInterests: String
    
    var bodyParameters: [String: String] {
        ["userName" : userName, "bio" : bio, "techInterests" : techInterests]
    }
}
