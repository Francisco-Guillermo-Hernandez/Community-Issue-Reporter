//
//  SignRequests.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI


struct SignRequestsView: View {
    @Namespace private var namespace
    @State private var model = PetitionDataModel.shared
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
        let locator = Locator(countryCode: "ES", country: "Spain", region: "Andalusia", city: "Seville", address: "Calle Falsa 123")
        
        await PetitionRepository.share.list(
            q: query,
            locator: locator,
            onComplete: { result in
                guard let documents = result.documents else { 
                    canLoadMore = false
                    return 
                }
                
                if reset {
                    self.petitions = documents
                } else {
                    let existingIds = Set(self.petitions.compactMap { $0.id })
                    let uniqueNewPetitions = documents.filter { doc in
                        guard let id = doc.id else { return true }
                        return !existingIds.contains(id)
                    }
                    self.petitions.append(contentsOf: uniqueNewPetitions)
                }
                
                self.canLoadMore = result.hasNext && self.currentPage < self.pageLimit
                if self.canLoadMore {
                    self.currentPage += 1
                }
                
            }, onError: { error in
                print(error)
                canLoadMore = false
            }
        )
        
        isLoading = false
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    headerView()
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Nearby Events")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        ForEach(petitions) { petition in
                            EventsOnDay(petition: petition, selectedIndex: petitions.firstIndex(where: { $0.id == petition.id }) ?? 0)
                                .task {
                                    if petition.id == petitions.last?.id {
                                        await fetchPetitions()
                                    }
                                }
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
                .padding(15)
            }
            .refreshable {
                await fetchPetitions(reset: true)
            }
            .customToolBar(isPrimaryActionVisible: isPrimaryActionVisible, title: title, subtitle: subtitle) {

            } trailing: {
                
                HStack(spacing: 16) {
                    
                    Button("Add", systemImage: "plus") {
                        showCreateRequestView.toggle()
                    }
                    .matchedTransitionSource(id: "openCreateRequest", in: namespace)


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
                            ForEach(OrderFilter.allCases, id: \.self) { filter in
                                Text(filter.title).tag(filter)
                            }
                        }
                       
                    } label: {
                        Label("Options", systemImage: "line.3.horizontal.decrease")
                    }
                }
                .padding(.horizontal, 4)
            } primaryAction: { }
        }
        .navigationTitle("Report")
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
            CreateRequestPetitionView(model: $model)
                .navigationTransition(
                    .zoom(sourceID: "openCreateRequest", in: namespace))
        }
        .sensoryFeedback(.selection, trigger: subtitle != nil)
        
    }
        
    
    /// Header View
    @ViewBuilder
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Sign Request Petitions")
                .font(.title.bold())
                .onGeometryChange(for: Bool.self) {
                    let height = abs($0.size.height - 5)
                    let offset = $0.frame(in: .global).minY
                    return -offset > height
                } action: { newValue in
                    title = newValue ? "Sign Request Petitions" : nil
                }

            
            Text("**125** Events   **5.6K** Subscribers")
                .font(.callout)
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.")
                .font(.callout)
                .lineLimit(5)
            

        }
        .padding(.bottom, 16)
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.horizontal, -16)
        }
    
    }

    @ViewBuilder
    func CenterDummyContent() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Latest petitions")
                    .font(.title3)
                    .fontWeight(.semibold)
                    
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            
            RoundedRectangle(cornerRadius: 32)
                .foregroundStyle(.gray.tertiary)
                .frame(height: 220)
        }
        .padding(.top, 10)
        .padding(.bottom, 20)
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.horizontal, -16)
        }
    }
    
    @ViewBuilder
    func EventsOnDay(petition: Petition, selectedIndex: Int) -> some View {
        
        
        VStack(alignment: .leading, spacing: 16) {
            Text(petition.title)
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
                    activeSubtitleIndex = newValue ? selectedIndex : (previousIndex < 0 ? nil : previousIndex)
                }
            
            NavigationLink(destination: PetitionDetailView(petition: petition)) {
                
                VStack( spacing: 16) {
                    RequestViewPost(petition: petition)
                }
            }
        }
    }
}


struct RequestViewPost: View {
    var petition: Petition
    var body: some View {
    
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 10) {
 
                Text("Category: \(getCategoryName(id: petition.categoryId))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                   
                Text("Target Signatures: \(petition.targetSignatures)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(petition.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
        
            }
                        
            Image(systemName: "chevron.compact.right")
        }
        .foregroundStyle(.gray.tertiary)
        
        Divider()
            .opacity(0.8)
    }
}

func getCategoryName(id: Int) -> String {
    return Categories.allCases.first(where: { $0.identifier == id })?.title ?? "Unknown"
}

#Preview {
    SignRequestsView()
}
