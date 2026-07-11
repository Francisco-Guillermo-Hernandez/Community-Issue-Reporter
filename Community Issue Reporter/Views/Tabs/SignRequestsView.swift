//
//  SignRequests.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI

enum SignRequestsViewsDestinations: Hashable {
    case comments(postId: String)
    case postDetail(of: PetitionPost)
}

struct SignRequestsView: View {
    @Namespace private var namespace
    @State private var controller = SignRequestController()
    @State private var petitionController = PetitionController()
    @State private var navigationPath: [SignRequestsViewsDestinations] = []
    
    fileprivate func posts() -> some View {
        return LazyVStack(alignment: .leading, spacing: .themeSpacing * 4) {
            headerView()
            
            VStack(alignment: .leading, spacing: .themeSpacing * 2) {
                
                ForEach(controller.petitions) { petition in
                    eventsOnDay(petition, selectedIndex: controller.getSelectedIndex(petition))
                    //                            .task {
                    //                                if petition.id == petitions.last?.id {
                    //                                    await fetchPetitions()
                    //                                }
                    //                            }
                }
                
                if controller.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                        Spacer()
                    }
                    .padding()
                }
            }
            
        }
        .customToolBar(
            isPrimaryActionVisible: controller.isPrimaryActionVisible,
            title: controller.title,
            subtitle: controller.subtitle
        ) {
            EmptyView()
        } trailing: {
            
            HStack(spacing: .themeSpacing * 4) {
                
                Button("Add", systemImage: "plus") {
                    controller.showCreateRequestView.toggle()
                }
                .matchedTransitionSource(
                    id: "openCreateRequest",
                    in: namespace
                )
                
                Menu {
                    Picker("Issue Type", selection: $controller.issueType) {
                        ForEach(IssueTypes.allCases, id: \.self) { type in
                            Text(type.title).tag(type)
                        }
                    }
                    
                    Picker("Severity", selection: $controller.severity) {
                        ForEach(Severity.allCases, id: \.self) { level in
                            Text(level.title).tag(level)
                        }
                    }
                    
                    Picker("Order Filter", selection: $controller.orderFilter) {
                        ForEach(OrderFilter.allCases, id: \.self) {
                            filter in
                            Text(filter.title).tag(filter)
                        }
                    }
                    
                } label: {
                    Label(
                        "Options",
                        systemImage: "line.3.horizontal.decrease"
                    )
                }
                
            }
            .padding(.horizontal, 4)
        } primaryAction: {
            EmptyView()
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            
            ZStack(alignment: .top) {
    
                Color.theme.background
                    .ignoresSafeArea()
                
                Color.orange.opacity(0.12)
                    .frame(height: 280)
                    .mask(
                        LinearGradient(
                            colors: [.white, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blur(radius: 60)
                    .ignoresSafeArea()
                
                ScrollView {
                    posts()
                        .navigationDestination(for: SignRequestsViewsDestinations.self) { destination in
                            switch destination {
                                case .comments(let id):
                                    CommentsSectionView(for: .petition, with: id, title: "", subtitle: "")
                                        .toolbar(.hidden, for: .tabBar)
                                        
                                    
                                case .postDetail(let petition):
                                    PetitionDetailView(petition: petition)
                                        .toolbar(.hidden, for: .tabBar)
                            }
                        }
                    
                }
                .toolbar(navigationPath.isEmpty ? .visible : .hidden, for: .tabBar)
                .animation(.easeInOut(duration: 0.35), value: navigationPath.isEmpty)
            }
            
//            .scrollContentBackground(.hidden)
//            .refreshable {
//                await fetchPetitions(reset: true)
//            }
            
        }
        .onChange(of: controller.activeSubtitleIndex) { oldValue, newValue in
            if let newValue {
                controller.subtitle = controller.petitions[newValue].title
            } else {
                controller.subtitle = nil
            }
        }
        .task {
            guard !Task.isCancelled else { return }
            await controller.fetchPetitions()
        }
        .onChange(of: controller.issueType) {
            Task { await controller.fetchPetitions(reset: true) }
        }
        .onChange(of: controller.severity) {
            Task { await controller.fetchPetitions(reset: true) }
        }
        .onChange(of: controller.orderFilter) {
            Task { await controller.fetchPetitions(reset: true) }
        }
        .sheet(isPresented: $controller.showCreateRequestView) {
            CreateRequestPetitionView(controller: petitionController, onCompletion: { _, _ in
                
            })
            .navigationTransition(
                .zoom(sourceID: "openCreateRequest", in: namespace)
            )
        }
        .sensoryFeedback(.selection, trigger: controller.subtitle != nil)
        
    }
    
    /// Header View
    @ViewBuilder
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: .themeSpacing * 4) {
            Text("**\(controller.petitions.count)** Petitions   **\(controller.signatureCount)** signatories")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("  ")
                .frame(height: 0)
                .font(.custom("Lora", size: 18, relativeTo: .title))
                .onGeometryChange(for: Bool.self) {
                    let height = abs($0.size.height - 5)
                    let offset = $0.frame(in: .global).minY
                    return -offset > height
                } action: { newValue in
                    controller.title = newValue ? "Petitions" : nil
                }
            
            
        }
        .padding(.horizontal, .themePadding)
    }
    
    @ViewBuilder
    func eventsOnDay(_ petition: PetitionPost, selectedIndex: Int) -> some View {
        
        VStack(alignment: .leading, spacing: .themeSpacing * 4) {
            VStack(alignment: .leading) {
                Text(petition.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .fontWidth(.condensed)
                    .lineLimit(1)
                    .padding(.top, .themePadding / 2)
                    .animation(.smooth(duration: 0.35, extraBounce: 0)) { content in
                        content
                            .opacity(controller.activeSubtitleIndex == selectedIndex ? 0 : 1)
//                            .scaleEffect(controller.activeSubtitleIndex == selectedIndex ? 0.02 : 1, anchor: .top)
                    }
                    .onGeometryChange(for: Bool.self) {
                        let offset = $0.frame(in: .scrollView).minY
                        return -offset > 25
                    } action: { newValue in
                        let previousIndex = selectedIndex - 1
                        controller.activeSubtitleIndex =
                        newValue
                        ? selectedIndex
                        : (previousIndex < 0 ? nil : previousIndex)
                    }
                
                Text(petition.description)
                    .font(.caption)
                    .lineLimit(1)
                    .opacity(0.85)
                
            }
            
            ///
            PostPublisher(petition: petition)
            
            Button {
                navigationPath.append(SignRequestsViewsDestinations.postDetail(of: petition))
            } label: {
                /// Images of the post
                PetitionViewPost(petition: petition)
            }
            
            Divider()
                .opacity(0.67)
            
            ///
            Gauge(value: petition.progress, in: 0...100) {
                Text(String(localized: "Progress", comment: "Signatures text at the bottom of the gauge"))
                    .font(.caption)
                    .fontWeight(.medium)
            } currentValueLabel: {
                Text("\(petition.percentage) of \(petition.targetSignatures) signatures")
            }
            .gaugeStyle(.accessoryLinearCapacity)
            
            ///
            VStack(alignment: .leading, spacing: .themeSpacing * 2) {
                HStack(alignment: .top) {
                    Signatories(users: petition.postSigners.latestsSigners)
                    
                    Text(controller.formatSigners(for: petition))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, .themeSpacing * 2)
                
                Divider()
                    .opacity(0.67)
                
                PostInteractions(
                    hasCurrentUserSigned: petition.postSigners.hasCurrentUserSigned,
                    sign: {
                        controller.showSignatureModal.toggle()
                    },
                    comment: {
                        navigationPath.append(SignRequestsViewsDestinations.comments(postId: petition.id))
                    },
                    share: {
                        let shareURL = buildShareURL(for: petition.postMetadata.shareLink)!
                        shareFromClosure(item: shareURL)
                    }
                )
                .sheet(isPresented: $controller.showSignatureModal) {
                    PreviewSignatureView(petitionName: "") {
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(.theme.foreground)
        .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
        .glassEffect(in: RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
        .padding(.bottom, .themePadding / 2)
    }
}

#Preview {
    SignRequestsView()
}
