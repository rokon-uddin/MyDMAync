//
//  DownloadStatus.swift
//  DownloadManager
//
//  Created by Mohammed Rokon Uddin on 16/11/25.
//

import Foundation

public enum DownloadStatus: Hashable {
    case idle
    case downloading
    case paused
    case finished
    case failed(DownloadError)
}
