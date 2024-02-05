//
//  AddEditPostController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/2/24.
//

import Foundation

class AddEditPostController {
    
    enum CreatePostError: Error, LocalizedError {
        case couldNotCreatePost
    }
    
    func createPost(secret: UUID, post: PostPost) async throws -> Post {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/createPost")!)
        
        let credentials: [String: Any] = ["userSecret" : secret.uuidString, "post" : post.createPostParamaters]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CreatePostError.couldNotCreatePost
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Post.self, from: data)
    }
    
    
}
