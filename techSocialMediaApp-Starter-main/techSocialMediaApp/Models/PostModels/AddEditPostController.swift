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
        case couldNotEditPost
    }
    
    func createPost(secret: UUID, post: PostPost) async throws -> Post {
        let session = URLSession.shared
        let url = URL(string: "/createPost", relativeTo: URL(string: API.url))
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
    
    func editPost(secret: UUID, post: PostPost) async throws -> Success {
        let session = URLSession.shared
        let url = URL(string: "/editPost", relativeTo: URL(string: API.url))
        var request = URLRequest(url: url!)
        
        let credentials: [String: Any] = ["userSecret" : secret.uuidString, "post" : post.editPostParameters]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CreatePostError.couldNotEditPost
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Success.self, from: data)
    }
    
    func deletePost(matching queryItems: [URLQueryItem]) async throws {
        var urlComponents = URLComponents(string: "\(API.url)/post")!
        
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "DELETE"
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func fetchPosts(matching queryItems: [URLQueryItem]) async throws -> [Post] {
        var urlComponents = URLComponents(string: "\(API.url)/posts")!
        
        urlComponents.queryItems = queryItems
        
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        
        return try JSONDecoder().decode([Post].self, from: data)
    }
}
