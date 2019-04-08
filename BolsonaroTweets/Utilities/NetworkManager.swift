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
            return "You need to be authenticated first.".localize
        case .badRequest:
            return "Bad request.".localize
        case .outdated:
            return "The url you requested is outdated.".localize
        case .failed:
            return "Network Request failed.".localize
        case .noData:
            return "Response returned with no data to decode.".localize
        case .unableToDecode:
            return  "We could not decode the response.".localize
        }
    }
}
