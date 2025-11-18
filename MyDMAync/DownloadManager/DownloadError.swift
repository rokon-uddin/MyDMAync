//
//  DownloadError.swift
//  DownloadManager
//
//  Created by Mohammed Rokon Uddin on 16/11/25.
//

import Foundation

public enum DownloadError: Swift.Error, Hashable {
    case serverError(statusCode: Int)
    case transportError(URLError, localizedDescription: String)
    case unknown(code: Int, localizedDescription: String)
    case aggregate(errors: Set<DownloadError>)

    public var description: String {
        switch self {
        case .serverError(statusCode: let code):
            return "Server error: \(code)"
        case .transportError(_, localizedDescription: let description):
            return description
        case .unknown(_, localizedDescription: let description):
            return description
        case .aggregate(errors: let errors):
            return "\(errors.count) errors occurred."
        }
    }
}
