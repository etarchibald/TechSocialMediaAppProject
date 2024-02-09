//
//  LikeController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/9/24.
//

import Foundation

struct UpdateLikes: APIRequest {
    var secret: UUID
    var postid: Int
    
    var urlRequest: URLRequest {
        let url = URL(string: "/updateLikes", relativeTo: URL(string: API.url))
        var request = URLRequest(url: url!)
        let credentials: [String : Any] = ["userSecret" : secret.uuidString, "postid" : String(postid)]
        request.httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func decodeData(_ data: Data) throws -> Post {
        return try JSONDecoder().decode(Post.self, from: data)
    }
}
