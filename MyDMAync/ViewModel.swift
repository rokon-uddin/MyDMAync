//
//  ViewModel.swift
//  MyDMAync
//
//  Created by Mohammed Rokon Uddin on 16/11/25.
//

import Foundation
import Combine

protocol ViewModelType: ObservableObject {
    var status: DownloadStatus { get }
    var queue: [Download] { get }

//    var progress: DownloadProgress { get }
    var throughput: Int { get }
    var estimatedTimeRemaining: TimeInterval? { get }

    func pause(_ download: Download)
    func resume(_ download: Download)
    func cancel(_ ids: Set<Download.ID>)
    func cancel(at offsets: IndexSet)
}

@MainActor
class ViewModel: ObservableObject {
    @Published var status: DownloadStatus
    @Published var queue = [Download]()
    @Published var throughput: Int = 0
    @Published var estimatedTimeRemaining: TimeInterval?

    @Published var manager: DownloadManager

    private var resumeData = [Download.ID: Data]()

    init(manager: DownloadManager) {
        self.manager = manager
        self.status = .idle
        Task { @MainActor in
            await manager.setDelegate(self)
        }
    }

    @MainActor
    convenience init() {
        self.init(manager: DownloadManager(sessionConfiguration: .default))
    }

    func download(_ items: [Item]) async {
        let downloads = items.map {
            Download(
                url: $0.url,
                progress: DownloadProgress(expected: Int64($0.estimatedSize))
            )
        }
        await manager.append(downloads)
    }

    func pause(_ download: Download) async {
        await manager.pause(download)
    }

    func resume(_ download: Download) async {
        await manager.resume(download)
    }

    func cancel(_ ids: Set<Download.ID>) {
//        let downloads = ids.compactMap(manager.download(with:))
//        manager.remove(Set(downloads))
    }

    func cancel(at offsets: IndexSet) {
//        let downloads = offsets.map { queue[$0] }
//        manager.remove(Set(downloads))
    }

    struct Item {
        let id: Int
        let url: URL
        let estimatedSize: Int
    }
}

extension ViewModel: DownloadManagerDelegate {
    func downloadQueueDidChange(_ items: [Download]) {
        print("queue changed (\(items.count))")
        queue = items
    }

    func downloadManagerStatusDidChange(_ status: DownloadStatus) {
        print("status changed: \(status)")
        self.status = status
    }

    func downloadDidUpdateProgress(_ download: Download) {
//        self.progress = download.progress
    }


    func downloadThroughputDidChange(_ throughput: Int) {
        self.throughput = throughput
        if throughput > 0 {
            Task { [weak self] in
                guard let self else { return }
                // Hop to the DownloadManager's actor to read its progress safely
                let progress = await self.manager.progress
                let expected = Double(progress.expected)
                let received = Double(progress.received)
                // Back on the main actor implicitly because ViewModel is @MainActor
                self.estimatedTimeRemaining = (expected - received) / Double(throughput)
            }
        } else {
            estimatedTimeRemaining = nil
        }
    }

    func downloadStatusDidChange(_ download: Download) {
        print("status changed for item: \(download.id)")
        download.objectWillChange.send()
    }

    func download(_ download: Download, didCreateTask _: URLSessionDownloadTask) {
        print("created task for url: \(download.url)")
    }

    func download(_: Download, didReconnectTask _: URLSessionDownloadTask) {}

    func download(_ download: Download, didCancelWithResumeData data: Data?) {
        if let data = data {
            print("saving \(data.count) bytes of resume data for download: \(download.id)")
        }

        resumeData[download.id] = data
    }

    func resumeDataForDownload(_ download: Download) -> Data? {
        resumeData[download.id]
    }

    func download(_: Download, didFinishDownloadingTo _: URL) {
        // TODO: move file from temporary location.
    }

    func downloadManagerDidFinishBackgroundDownloads() {
        // TODO: call background completion handler.
    }
}

extension Progress {
    static func download(
        fraction: Double,
        totalUnitCount: Int64 = 0,
        throughput: Int? = nil
    ) -> Progress {
        let progress = Progress()
        progress.kind = .file
        progress.fileOperationKind = .downloading
        progress.throughput = throughput
        progress.completedUnitCount = Int64(100.0 * fraction)
        progress.totalUnitCount = totalUnitCount
        return progress
    }
}

