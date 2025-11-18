//
//  DownloadManagerDelegate.swift
//  DownloadManager
//
//  Created by Mohammed Rokon Uddin on 16/11/25.
//

import Foundation

public protocol DownloadManagerDelegate: AnyObject {
    func downloadQueueDidChange(_ downloads: [Download])

    func downloadThroughputDidChange(_ throughput: Int)

    func downloadDidUpdateProgress(_ download: Download)

    func downloadStatusDidChange(_ download: Download)

    func download(_ download: Download, didCreateTask: URLSessionDownloadTask)

    func download(_ download: Download, didReconnectTask: URLSessionDownloadTask)

    func download(_ download: Download, didFinishDownloadingTo location: URL)

    func download(_ download: Download, didCancelWithResumeData resumeData: Data?)

    func resumeDataForDownload(_ download: Download) -> Data?

    func downloadManagerDidFinishBackgroundDownloads()
}
