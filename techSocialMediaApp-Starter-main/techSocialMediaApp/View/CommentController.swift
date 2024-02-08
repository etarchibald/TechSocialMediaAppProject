//
//  CommentController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/7/24.
//

import Foundation

struct FetchComments: APIRequest{
    var secret: UUID
    var postid: Int
    var pageNumber: Int
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "\(API.url)/comments")!
        let secretQueryItem = URLQueryItem(name: "userSecret", value: secret.uuidString)
        let postIDQueryItem = URLQueryItem(name: "postid", value: String(postid))
        let pageNumberQueryItem = URLQueryItem(name: "pageNumber", value: String(pageNumber))
        urlComponents.queryItems = [secretQueryItem, postIDQueryItem, pageNumberQueryItem]
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodeData(_ data: Data) throws -> [Comment] {
        return try JSONDecoder().decode([Comment].self, from: data)
    }
}

struct CreateCommet: APIRequest {
    var secret: UUID
    var commentBody: String
    var postid: Int
    
    var urlRequest: URLRequest {
        let url = URL(string: "/createComment", relativeTo: URL(string: API.url))
        var request = URLRequest(url: url!)
        let credentials: [String : Any] = ["userSecret" : secret.uuidString, "commentBody" : commentBody, "postid" : String(postid)]
        request.httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func decodeData(_ data: Data) throws -> Comment {
        return try JSONDecoder().decode(Comment.self, from: data)
    }
}
