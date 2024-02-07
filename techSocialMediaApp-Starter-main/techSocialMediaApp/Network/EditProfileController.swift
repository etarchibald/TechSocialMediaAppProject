//
//  EditProfileController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/31/24.
//

import Foundation

struct EditProfilePost: APIRequest {
    var secret: UUID
    var postProfile: PostProfile
    
    var urlRequest: URLRequest {
        let url = URL(string: "/updateProfile", relativeTo: URL(string: API.url))
        var request = URLRequest(url: url!)
        let credentials: [String : Any] = ["userSecret" : secret.uuidString, "profile" : postProfile.bodyParameters]
        request.httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func decodeData(_ data: Data) throws -> Success {
       return try JSONDecoder().decode(Success.self, from: data)
    }
}
