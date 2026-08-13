//
//  PhotoPreview.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI

// MARK: - Enum definitions

enum PhotoPreviewMode {
    case sized
    case full
}

enum ContentViolationReportOptions: String, Codable, CaseIterable {
    case explicitContent
    case spam
    case violence
    case privacyIssues
    case other
    
    var description: String {
        switch self  {
            case .explicitContent:
                return String(localized: "Explicit Content")
            case .spam:
                return String(localized: "Spam")
            case .violence:
                return String(localized: "Violence")
            case .privacyIssues:
                return String(localized: "Privacy issue")
            case .other:
                return String(localized: "Other")
            
        }
    }
}

// MARK: Views
struct PhotoPreview: View {
    let options = ContentViolationReportOptions.allCases.map(\.description)
    
    @State private var selectedOption = "None"
    @State private var showPopover = false
    @State private var presentAlert: Bool = false
    @State private var cornerRadius: CGFloat = .themeRadius * 1.4
    @State private var reason: String = ""
    var height: CGFloat = 170
    var width: CGFloat = 170
    
    var mode: PhotoPreviewMode
    var attachment: PreviewAttachment
    
    init(_ attachment: PreviewAttachment, _ mode: PhotoPreviewMode = .sized) {
        self.attachment = attachment
        self.mode = mode
    }
    
    init (_ attachment: PreviewAttachment, height: CGFloat, width: CGFloat) {
        
        self.attachment = attachment
        self.height = height
        self.width = width
        self.mode = .sized
    }
    
    var body: some View {
        if let url = attachment.url {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: mode == .sized ? width : nil,
                        height: mode == .sized ? height : nil,
                        alignment: .top
                    )
                    .frame(
                        maxWidth: mode == .full ? .infinity : nil,
                        maxHeight: mode == .full ? .infinity : nil,
                        alignment: .top
                    )
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .overlay {
                        ZStack(alignment: .bottomLeading) {
                            
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            .init(color: .black.opacity(0.6), location: 0),
                                            .init(color: .black.opacity(0.33), location: 0.5),
                                            .init(color: .clear, location: 1)
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                                .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(userAlias(attachment.uploaderUserName))
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Text(attachment.createdAt.formatted(date: .numeric, time: .omitted))
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(12)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                          
                        Button {
                            showPopover.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .padding(6)
                        }
                        .buttonBorderShape(.circle)
                        .buttonStyle(.glass)
                        .popover(isPresented: $showPopover, arrowEdge: .top) {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Content options")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 5)
                                
                                ForEach(options, id: \.self) { option in
                                    Button(action: {
                                        Task {
                                            selectedOption = option
                                            showPopover = false /// Closes popover upon selection
                                            try? await Task.sleep(for: .milliseconds(128))
                                            presentAlert.toggle()
                                        }
                                    }) {
                                        HStack {
                                            Text(option)
                                            
                                            Spacer()
                                        }
                                        .contentShape(Rectangle()) /// Ensures the whole row is clickable
                                    }
                                    .foregroundColor(.primary)
                                    
                                    if option != options.last {
                                        Divider() /// Visual separator between choices
                                    }
                                }
                            }
                            .padding()
                            .frame(width: 256) /// Sets a fixed width for desktop/iPad presentation
                            .presentationCompactAdaptation(.popover) /// Forces popover look on iPhone
                        }
                        .padding(.top, 10)
//                        .padding(.trailing, 8)
                        .alert(String(localized: "Confirm content blocking"), isPresented: $presentAlert) {
                            
                            TextField(String(localized: "Type your reason"), text: $reason)
                            
                            Button(String(localized: "Cancel"), role: .cancel) { }
                            Button(String(localized: "Block"), role: .destructive) {
                                Task {
                                    
                                }
                            }
                        } message: {
                            Text(String(localized: "I confirm that this content violates our community guidelines."))
                        }
                        
                    }
                   
            } placeholder: {
                ProgressView()
                    .frame(width: width, height: height)
            }
            .id(url)
        }
    }
}

#Preview {
    let attachment = PreviewAttachment(
        id: "24b93d66-07ff-4141-91ce-408b615123c3",
        type: .image,
        createdAtRaw: 0,
        updatedAtRaw: 0,
        uploaderUserName: "jhon.doe",
        validatedBy: .bot,
        state: .pending,
        fileName: "1783058838224-f02fb5e4-07d1-49d4-a9f5-742816b669c9.webp",
        reportContainer: "587d3ac3-0715-4958-8955-1d6d29a3d489"
    )
    PhotoPreview(attachment)
}


