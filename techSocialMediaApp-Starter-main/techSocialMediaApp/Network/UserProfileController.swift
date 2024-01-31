//
//  UserProfileController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/30/24.
//

import Foundation

class UserProfileController {
    
    func fetchUserProfile(matching queryItems: [URLQueryItem]) async throws -> UserProfile {
        var urlComponents = URLComponents(string: "\(API.url)/userProfile")!
        
        urlComponents.queryItems = queryItems
        
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        
        return try JSONDecoder().decode(UserProfile.self, from: data)
    }
}
