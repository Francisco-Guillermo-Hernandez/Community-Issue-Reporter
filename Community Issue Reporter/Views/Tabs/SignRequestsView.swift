//
//  SignRequests.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI

struct SimpleCommentsView: View {
    var id: String
    var body: some View {
        Text(id)
    }
}

struct SimpleDetailView: View {
    var other: String
    var body: some View {
        Text("ddd")
    }
}

enum SignRequestsViewsDestinations: Hashable {
    case comments(postId: String)
    case postDetail(of: Petition)
}

struct SignRequestsView: View {
    @Namespace private var namespace
    @State private var isPrimaryActionVisible: Bool = true
    @State private var title: String?
    @State private var subtitle: String?
    @State private var activeSubtitleIndex: Int?
    @State private var isSearchBarVisible: Bool = false
    @State private var searchText: String = ""
    @State private var issueType: IssueTypes = .road
    @State private var orderFilter: OrderFilter = .ascending
    @State private var severity: Severity = .low
    @State private var selectedItem: Int?
    @State private var petitions: [Petition] = []
    @State private var showCreateRequestView: Bool = false
    @State private var currentPage: Int = 1
    @State private var isLoading: Bool = false
    @State private var canLoadMore: Bool = true
    private let pageLimit: Int = 16
    @State private var value: Double = 20
    
    @State private var navigationPath: [SignRequestsViewsDestinations] = []
    
    @State private var signatureCount: Int = 125
    
    @State private var users: [User] = [
        User(username: "janeDoe", avatar: "user"),
        User(username: "mayDoe", avatar: "user"),
        User(username: "mperez", avatar: "user"),
    ]
    
    @Sendable
    func fetchPetitions(reset: Bool = false) async {
        if reset {
            currentPage = 1
            canLoadMore = true
        }
        
        guard !isLoading && (canLoadMore || reset) else { return }
        
        isLoading = true
        
        let query = PaginatedRequestQueryParams(
            page: currentPage,
            limit: 10,
            issueTypeId: issueType == .all ? nil : issueType.identifier,
            severityId: severity == .all ? nil : severity.identifier,
            ordering: orderFilter
        )
        
        // In a real app, this locator might come from a location service
        let locator = Locator(
            countryCode: "ES",
            country: "Spain",
            region: "Andalusia",
            city: "Seville",
            address: "Calle Falsa 123"
        )
        
        self.petitions = [
            Petition(
                id: "1",
                title: "Hay un bache en la calle",
                description: "un bache esta causando que los carros se dañen",
                targetSignatures: 22,
                currentSignatures: 0,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 799056444.493906),
                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ]
            ),
            Petition(
                id: "2",
                title: "Un semaforo no esta funcionando en la avenida",
                description: "Un semaforo esta funcionando mal",
                targetSignatures: 22,
                currentSignatures: 0,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 799056444.493906),
                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ]
            ),
            Petition(
                id: "3",
                title: "Hay una fuga de agua en la colonia",
                description: "",
                targetSignatures: 22,
                currentSignatures: 0,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 799056444.493906),
                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ]
            ),
        ]
        
        self.petitions.append(contentsOf: petitions)
        
//        await PetitionRepository.share.list(
//            q: query,
//            locator: locator,
//            onComplete: { result in
//                guard let documents = result.documents else {
//                    canLoadMore = false
//                    return
//                }
//                
//                if reset {
//                    self.petitions = documents
//                } else {
//                    let existingIds = Set(self.petitions.compactMap { $0.id })
//                    let uniqueNewPetitions = documents.filter { doc in
//                        guard let id = doc.id else { return true }
//                        return !existingIds.contains(id)
//                    }
//                    self.petitions.append(contentsOf: uniqueNewPetitions)
//                }
//                
//                self.canLoadMore = result.hasNext && self.currentPage < self.pageLimit
//                if self.canLoadMore {
//                    self.currentPage += 1
//                }
//                
//            }, onError: { error in
//                print(error)
//                canLoadMore = false
//            }
//        )
        
        isLoading = false
    }
    
    @State private var level: Int = 20
    @State var model = PetitionDataModel()
    
    fileprivate func posts() -> some View {
        return LazyVStack(alignment: .leading, spacing: .themeSpacing * 4) {
            headerView()
            
            VStack(alignment: .leading, spacing: .themeSpacing * 2) {
                
                
                ForEach(petitions) { petition in
                    EventsOnDay(
                        petition: petition,
                        selectedIndex: petitions.firstIndex(where: {
                            $0.id == petition.id
                        }) ?? 0
                    )
                    //                            .task {
                    //                                if petition.id == petitions.last?.id {
                    //                                    await fetchPetitions()
                    //                                }
                    //                            }
                }
                
                if isLoading {
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
            isPrimaryActionVisible: isPrimaryActionVisible,
            title: title,
            subtitle: subtitle
        ) {} trailing: {
            
            HStack(spacing: 16) {
                
                Button("Add", systemImage: "plus") {
                    showCreateRequestView.toggle()
                }
                .matchedTransitionSource(
                    id: "openCreateRequest",
                    in: namespace
                )
                
                
                Menu {
                    Picker("Issue Type", selection: $issueType) {
                        ForEach(IssueTypes.allCases, id: \.self) { type in
                            Text(type.title).tag(type)
                        }
                    }
                    
                    Picker("Severity", selection: $severity) {
                        ForEach(Severity.allCases, id: \.self) { level in
                            Text(level.title).tag(level)
                        }
                    }
                    
                    Picker("Order Filter", selection: $orderFilter) {
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
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                posts()
                    .navigationDestination(for: SignRequestsViewsDestinations.self) { destination in
                        switch destination {
                        case .comments(let id):
                            SimpleCommentsView(id: id)
                        case .postDetail(let petition):
                            PetitionDetailView(petition: petition)
                        }
                    }
                
            }
         
            
//            .background(Color.theme.background)
//            .scrollContentBackground(.hidden)
//            .refreshable {
//                await fetchPetitions(reset: true)
//            }
            
        }
        
        .onChange(of: activeSubtitleIndex) { oldValue, newValue in
            if let newValue {
                subtitle = petitions[newValue].title
            } else {
                subtitle = nil
            }
        }
        .task {
            guard !Task.isCancelled else { return }
            await fetchPetitions()
        }
        .onChange(of: issueType) {
            Task { await fetchPetitions(reset: true) }
        }
        .onChange(of: severity) {
            Task { await fetchPetitions(reset: true) }
        }
        .onChange(of: orderFilter) {
            Task { await fetchPetitions(reset: true) }
        }
        .sheet(isPresented: $showCreateRequestView) {
            CreateRequestPetitionView(model: model, onCompletion: { _, _ in
                
            })
                .navigationTransition(
                    .zoom(sourceID: "openCreateRequest", in: namespace)
                )
        }
        .sensoryFeedback(.selection, trigger: subtitle != nil)
        
    }
    
    /// Header View
    @ViewBuilder
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: .themeSpacing * 4) {
            Text("**\(petitions.count)** Petitions   **\(signatureCount)** signatories")
//                .font(Font.headline)
                .font(.subheadline)
//                .font(.custom("Lora", size: 16, relativeTo: .title))
                .foregroundColor(.secondary)
            Text("  ")
                .frame(height: 0)
//                .font(.title.bold())
                .font(.custom("Lora", size: 18, relativeTo: .title))
                .onGeometryChange(for: Bool.self) {
                    let height = abs($0.size.height - 5)
                    let offset = $0.frame(in: .global).minY
                    return -offset > height
                } action: { newValue in
                    title = newValue ? "Petitions" : nil
                }
            
            
        }
        .padding(.horizontal, .themePadding)
    }
    
    @ViewBuilder
    func EventsOnDay(petition: Petition, selectedIndex: Int) -> some View {
        
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text(petition.title)
                    .font(.title2)
//                    .font(.custom("Lora", size: 16, relativeTo: .title))
                    .fontWeight(.black)
                    .fontWidth(.condensed)
                    .lineLimit(1)
                    .animation(.smooth(duration: 0.35, extraBounce: 0)) { content in
                        content
                            .opacity(activeSubtitleIndex == selectedIndex ? 0 : 1)
                        //                        .scaleEffect(activeSubtitleIndex == index ? 0.01 : 1, anchor: .top)
                    }
                    .onGeometryChange(for: Bool.self) {
                        let offset = $0.frame(in: .scrollView).minY
                        return -offset > 25
                    } action: { newValue in
                        let previousIndex = selectedIndex - 1
                        activeSubtitleIndex =
                        newValue
                        ? selectedIndex
                        : (previousIndex < 0 ? nil : previousIndex)
                    }
                
                Text(petition.description)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                
                  
            }
            
            
            PostPublisher()
            
            /// Go to detail 
//            NavigationLink(destination: PetitionDetailView(petition: petition)) {
//                
//                VStack(spacing: .themeSpacing) {
//                    PetitionViewPost(petition: petition)
//                        .scrollClipDisabled(true)
//                }
//            }
            
            Button {
                navigationPath.append(SignRequestsViewsDestinations.postDetail(of: petition))
            } label: {
                PetitionViewPost(petition: petition)
//                    .scrollClipDisabled(true)
            }
            
            Divider()
                .opacity(0.6)
            
            Gauge(value: value, in: 0...100) {
                Text(String(localized: "Signatures", comment: "Signatures text at the bottom of the gauge"))
                    .font(.caption)
                    .fontWeight(.medium)
            } currentValueLabel: {
                Text("\(Int(value)) %")
            }
            .gaugeStyle(.accessoryLinearCapacity)
            
            
            VStack(alignment: .leading, spacing: .themeSpacing * 2) {
                HStack(alignment: .top) {
                    Signatories(users: users)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("125 signatories")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, .themeSpacing * 2)
                
                Divider()
                    .opacity(0.6)
                
                PostInteractions(
                    sign: {
                        
                    },
                    comment: {
                        navigationPath.append(SignRequestsViewsDestinations.comments(postId: "sample"))
                    },
                    share: {
                        let shareURL = buildShareURL(for: "7BTheYpPwK1L/report/traffic-light-ou")!
                        shareFromClosure(item: shareURL)
                    }
                )
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(.theme.foreground)
        .background(Color.theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
        .glassEffect(in: RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
        .padding(.bottom, .themePadding / 2)

        
    }
}


func getCategoryName(id: Int) -> String {
    return Categories.allCases.first(where: { $0.identifier == id })?.title
    ?? "Unknown"
}

#Preview {
    SignRequestsView()
}

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
