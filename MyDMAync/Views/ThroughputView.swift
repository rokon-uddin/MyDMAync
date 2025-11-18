//
//  ThroughputView.swift
//  DownloadManagerUI
//
//  Created by Mohammed Rokon Uddin on 16/11/25.
//

import SwiftUI

struct ThroughputView: View {
    private let throughputProgress = Progress.download(fraction: 0)
    private let timeRemainingProgress = Progress.download(fraction: 0)

    init(throughput: Int, estimatedTimeRemaining: TimeInterval?) {
        throughputProgress.throughput = throughput
        timeRemainingProgress.estimatedTimeRemaining = estimatedTimeRemaining
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(throughputProgress.localizedAdditionalDescription)
            Text(timeRemainingProgress.localizedAdditionalDescription)
        }
    }
}
