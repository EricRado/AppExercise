//
//  Router.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/13/19.
//

import Foundation
import Alamofire

public enum Router: URLRequestConvertible {
    enum Constants {
        static let baseURLPath = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/"
    }
    
    case master(String)
    
    var method: HTTPMethod {
        switch self {
        case .master:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .master(let filename):
            return "/master/\(filename)"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .master:
            return [:]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
