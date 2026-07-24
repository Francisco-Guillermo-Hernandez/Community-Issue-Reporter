//
//  PetitionDetailView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/2/26.
//

import SwiftUI

// MARK: - View
struct PetitionDetailView: View {
    var petition: PetitionPost
    var offline: Bool = false
    
    @State private var currentImageIndex: Int = 0
    @State private var autoScrollTimer: Timer?
    @State private var showSignatureModal: Bool = false
    
    private let autoScrollInterval: TimeInterval = 4.0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: - Image Carousel
                imageCarousel
                
                // MARK: - Content
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Publisher info
                    PostPublisher(petition: petition)
                        .padding(.top, 16)
                    
                    SectionHeader(title: "Description")
                    Text(petition.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    SectionHeader(title: "Category")
                    Text(getCategoryName(id: petition.categoryId))
                    
                    SectionHeader(title: "Location")
                    HStack(alignment: .top, spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 32, height: 32)
                            Image(systemName: "mappin")
                                .foregroundStyle(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Intersection of Main St and Elm St")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("123 Main St, Anytown, USA")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Text("Latitude: 99")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Text("Longitude: 99")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    SectionHeader(title: "Severity")
                    HStack(spacing: 16) {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 32, height: 32)
                            .overlay {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundStyle(.gray)
                            }
                        Text("High")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    SectionHeader(title: "Confirmation Status")
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.seal")
                            .foregroundStyle(.gray)
                        Text("Confirmed by 3 users")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    SectionHeader(title: "Petition")
                    VStack(spacing: 8) {
                        Gauge(value: petition.progress, in: 0...100) {
                            Text(String(localized: "Signatures", comment: "Signatures text at the bottom of the gauge"))
                                .font(.caption)
                                .fontWeight(.medium)
                        } currentValueLabel: {
                            Text("\(petition.percentage) of \(petition.targetSignatures) signatures")
                        }
                        .gaugeStyle(.accessoryLinearCapacity)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Signatories
                    if !petition.postSigners.latestsSigners.isEmpty {
                        Signatories(users: petition.postSigners.latestsSigners)
                    }
                    
                    /// Comments section
                    SectionHeader(title: "Comments")
                    
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100) // Extra space for the bottom button
            }
        }
        .background(Color.theme.background)
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom, spacing: 0) {
//            bottomSignButton
            
           
            BottomFadedView {
                ThemedButton(message: "Sign", action: {}, type: .primary, style: .prominent, icon: "signature")
                    .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                Text(petition.title)
            }
            
            ToolbarSpacer(.fixed)
            
            ToolbarItem() {
                ShareLink(item: buildShareURL(for: petition.postMetadata.shareLink)!) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        .onAppear { startAutoScroll() }
        .onDisappear { stopAutoScroll() }
        .sheet(isPresented: $showSignatureModal) {
            PreviewSignatureView(petitionName: petition.title) {
                
            }
        }
    }
}

// MARK: - Subviews
extension PetitionDetailView {
    
    /// Full-width image carousel with auto-scroll and swipe gesture
    @ViewBuilder
    private var imageCarousel: some View {
        if !petition.attachments.isEmpty {
            ZStack(alignment: .bottom) {
                TabView(selection: $currentImageIndex) {
                    ForEach(Array(petition.attachments.enumerated()), id: \.element.id) { index, attachment in
                        PhotoPreview(attachment, height: UIScreen.main.bounds.width, width: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 300)
                
                // Bottom gradient overlay
                LinearGradient(
                    stops: [
                        .init(color: Color.theme.background, location: 0),
                        .init(color: Color.theme.background.opacity(0.6), location: 0.4),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 80)
                .allowsHitTesting(false)
                
                // Page indicator
                pageIndicator
                    .padding(.bottom, 12)
            }
            .onChange(of: currentImageIndex) {
                // Reset auto-scroll timer when user swipes manually
                restartAutoScroll()
            }
        }
    }
    
    /// Custom pill-style page indicator (inspired by the App Store carousel)
    private var pageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<petition.attachments.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentImageIndex ? Color.white : Color.white.opacity(0.4))
                    .frame(
                        width: index == currentImageIndex ? 20 : 7,
                        height: 7
                    )
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: currentImageIndex)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
    }
    
    /// Bottom "Sign Petition" sticky button
    private var bottomSignButton: some View {
        Button {
            showSignatureModal.toggle()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: petition.postSigners.hasCurrentUserSigned ? "checkmark.circle.fill" : "signature")
                    .font(.body.weight(.semibold))
                
                Text(petition.postSigners.hasCurrentUserSigned
                     ? String(localized: "Already Signed")
                     : String(localized: "Sign Petition"))
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .disabled(petition.postSigners.hasCurrentUserSigned)
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Auto-Scroll
extension PetitionDetailView {
    
    private func startAutoScroll() {
        guard petition.attachments.count > 1 else { return }
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentImageIndex = (currentImageIndex + 1) % petition.attachments.count
            }
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    private func restartAutoScroll() {
        stopAutoScroll()
        startAutoScroll()
    }
}

// MARK: - Section
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
//            .padding(.top, 16)
//            .kerning(0.6)
            .fontWeight(.bold)
//            .fontWidth(.condensed)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {

    NavigationStack {
        PetitionDetailView(petition: PetitionsPostMockedData.shared.petitions[0])
    }
}
