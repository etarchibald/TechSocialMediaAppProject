//
//  Success.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/2/24.
//

import Foundation

struct Success: Decodable {
    var success: Bool?
    var message: String?
    
    enum CodingKeys: CodingKey {
        case success
        case message
    }
}
