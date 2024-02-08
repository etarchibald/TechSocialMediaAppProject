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
