//
//  UploadProgressView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/4/26.
//

import SwiftUI


struct UploadProgressView: View {
    let reportId: String
    @Binding var images: [UIImage]
    @Environment(\.dismiss) var dismiss
    
    @State private var uploadStates: [ImageUploadState] = []
    @State private var isProcessing = false
    @State private var showFinalMessage = false
    
    var body: some View {
        NavigationStack {
            List(uploadStates) { state in
                HStack(spacing: 15) {
                    Image(uiImage: state.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading) {
                        Text(statusLabel(for: state.status))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if state.status == .encoding || state.status == .uploading {
                            ProgressView()
                                .controlSize(.small)
                        }
                    }
                    
                    Spacer()
                    
                    statusIcon(for: state.status)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Uploading Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if showFinalMessage {
                        Button("Done") { dismiss() }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if showFinalMessage {
                    Text("All images uploaded successfully!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                        .transition(.move(edge: .bottom))
                }
            }
            .onAppear {
                setupAndStartUpload()
            }
            .interactiveDismissDisabled(isProcessing)
        }
    }
    
    // MARK: - Helpers
    
    private func setupAndStartUpload() {
        self.uploadStates = images.map { ImageUploadState(image: $0) }
        self.isProcessing = true
        
        Task {
            await ImageEncoderService().prepareAndSend(
                reportId: reportId,
                states: $uploadStates
            ) {
                self.isProcessing = false
                self.showFinalMessage = true
            }
        }
    }
    
    private func statusLabel(for status: UploadStatus) -> String {
        switch status {
        case .pending: return "Waiting..."
        case .encoding: return "Encoding to WebP..."
        case .uploading: return "Uploading to server..."
        case .success: return "Completed"
        case .failure: return "Failed to upload"
        }
    }
    
    @ViewBuilder
    private func statusIcon(for status: UploadStatus) -> some View {
        switch status {
        case .success:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .failure:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
        default:
            EmptyView()
        }
    }
}


enum UploadStatus {
    case pending, encoding, uploading, success, failure
}

struct ImageUploadState: Identifiable {
    let id = UUID()
    let image: UIImage
    var status: UploadStatus = .pending
}
