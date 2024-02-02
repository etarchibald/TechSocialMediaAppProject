//
//  PostPost.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/2/24.
//

import Foundation

struct PostPost {
    var postid: Int?
    var title: String
    var body: String
    
    var createPostParamaters: [String : String] {
        ["title" : title, "body" : body]
    }
    
    var editPostParameters: [String : Any] {
        ["postid" : postid!, "title" : title, "body" : body]
    }
}
