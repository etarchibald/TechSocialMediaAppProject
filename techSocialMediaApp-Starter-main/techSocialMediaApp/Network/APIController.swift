//
//  APIController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/7/24.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeData(_ data: Data) throws -> Response
}

enum APIError: Error, LocalizedError {
    case APIError
}

class APIController {
    
    static var shared = APIController()
    
    func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let session = URLSession.shared
        let (data, response) = try await session.data(for: request.urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else { throw APIError.APIError }
        return try request.decodeData(data)
    }
}
