//
//  UserProfileController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/30/24.
//

import Foundation


struct fetchUserProfile: APIRequest {
    var userUUID: UUID
    var secret: UUID
    
    var urlRequest: URLRequest {
        var components = URLComponents(string: "\(API.url)/userProfile")!
        let userQueryItem = URLQueryItem(name: "userUUID", value: userUUID.uuidString)
        let secretQueryItem = URLQueryItem(name: "userSecret", value: secret.uuidString)
        components.queryItems = [userQueryItem, secretQueryItem]
        return URLRequest(url: components.url!)
    }
    
    func decodeData(_ data: Data) throws -> UserProfile {
        let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
        return userProfile
    }
}
