//
//  AddEditPostController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/2/24.
//

import Foundation

struct CreatePost: APIRequest {
    var secret: UUID
    var post: PostPost
    
    var urlRequest: URLRequest {
        let url = URL(string: "/createPost", relativeTo: URL(string: API.url))
        var request = URLRequest(url: url!)
        let credentials: [String: Any] = ["userSecret" : secret.uuidString, "post" : post.createPostParamaters]
        request.httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func decodeData(_ data: Data) throws -> Post {
        return try JSONDecoder().decode(Post.self, from: data)
    }
}

struct EditPost: APIRequest {
    var secret: UUID
    var post: PostPost
    
    var urlRequest: URLRequest {
        let url = URL(string: "/editPost", relativeTo: URL(string: API.url))
        var request = URLRequest(url: url!)
        
        let credentials: [String: Any] = ["userSecret" : secret.uuidString, "post" : post.editPostParameters]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func decodeData(_ data: Data) throws -> Success {
        return try JSONDecoder().decode(Success.self, from: data)
    }
}

struct DeletePost: APIRequest {
    var secret: UUID
    var postid: Int
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "\(API.url)/post")!
        let secretQueryItem = URLQueryItem(name: "userSecret", value: secret.uuidString)
        let postidQueryItem = URLQueryItem(name: "postid", value: String(postid))
        urlComponents.queryItems = [secretQueryItem, postidQueryItem]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "DELETE"
        return request
    }
    
    func decodeData(_ data: Data) throws -> Success {
        return try JSONDecoder().decode(Success.self, from: data)
    }
}

struct FetchPosts: APIRequest {
    var secret: UUID
    var pageNumber: Int
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "\(API.url)/posts")!
        let secretQueryItem = URLQueryItem(name: "userSecret", value: secret.uuidString)
        let pageNumberQueryItem = URLQueryItem(name: "pageNumber", value: String(pageNumber))
        urlComponents.queryItems = [secretQueryItem, pageNumberQueryItem]
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodeData(_ data: Data) throws -> [Post] {
        return try JSONDecoder().decode([Post].self, from: data)
    }
}
