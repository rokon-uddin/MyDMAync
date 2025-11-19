//
//  MyDMAyncApp.swift
//  MyDMAync
//
//  Created by Mohammed Rokon Uddin on 16/11/25.
//

import SwiftUI

private enum Constants {
    static let httpbin = URL(string: "https://httpbin.org")!
    static let downloadCount = 30
    /// Max httpbin file size (~100kb).
    static let maxFileSize = 99999
}

@main
struct MyDMAyncApp: App {
    let viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            DownloadManagerView(viewModel: viewModel)
                .onAppear {
                    Task {
                        await viewModel.download((0 ..< Constants.downloadCount).map { index -> ViewModel.Item in
                            let size = Int.random(in: 99900 ... Constants.maxFileSize)
                            return .init(
                                id: index,
                                url: Constants.httpbin.appendingPathComponent("/bytes/\(size)"),
                                estimatedSize: size
                            )
                        })
                    }
                }
        }
    }
}
