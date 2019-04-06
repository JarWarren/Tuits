//
//  NetworkManager.swift
//  DevMountain
//
//  Created by Jared Warren on 4/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

protocol NetworkManager {
    static func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkResponse>
}

extension NetworkManager {
    static func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkResponse> {
        switch response.statusCode {
        case 200...299:
            return .success(true)
        case 401...500:
            return .failure(NetworkResponse.authenticationError)
        case 501...599:
            return .failure(NetworkResponse.badRequest)
        case 600:
            return .failure(NetworkResponse.outdated)
        default:
            return .failure(NetworkResponse.failed)
        }
    }
}

enum NetworkResponse: Error {
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    
    var localizedDescription: String {
        switch self {
        case .success:
            return String()
        case .authenticationError:
            return "You need to be authenticated first."
        case .badRequest:
            return "Bad request."
        case .outdated:
            return "The url you requested is outdated"
        case .failed:
            return "Network Request failed."
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return  "We could not decode the response."
        }
    }
}
