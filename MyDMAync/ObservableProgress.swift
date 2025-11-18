//
//  ObservableProgress.swift
//  DownloadManagerUI
//
//  Created by Mohammed Rokon Uddin on 16/11/25.
//

import Combine
import Foundation

@MainActor
class ObservableProgress: ObservableObject {
    private let _progress: Progress = .download(fraction: 0)
    private let progress: DownloadProgress

    @Published var fractionCompleted: Double = 0

    var totalUnitCount: Int64 {
        progress.expected
    }

    var completedUnitCount: Int64 {
        progress.received
    }

    var localizedAdditionalDescription: String {
        _progress.localizedAdditionalDescription
    }

    init(progress: DownloadProgress) {
        self.progress = progress
        progress.$fractionCompleted
            .receive(on: DispatchQueue.main)
            .assign(to: &$fractionCompleted)
    }
}
