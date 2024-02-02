//
//  EditProfileController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/31/24.
//

import Foundation

class EditProfileController {
    
    enum EditProfileError: Error, LocalizedError {
        case couldNotEdit
    }
    
    func editProfilePost(secret: UUID, postProfile: PostProfile) async throws -> Success {
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/updateProfile")!)
        
        let credentials: [String: Any] = ["userSecret" : secret.uuidString, "profile" : postProfile.bodyParameters]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw EditProfileError.couldNotEdit
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        return try decoder.decode(Success.self, from: data)
    }
}
