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
        let url = URL(string: "/createPost", relativeTo: URL(string:API.url))
        var request = URLRequest(url: url!)
        
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
    
    func deletePost(matching queryItems: [URLQueryItem]) async throws {
        var urlComponents = URLComponents(string: "\(API.url)/post")!
        
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "DELETE"
        let (data, _) = try await URLSession.shared.data(for: request)
    }
}
