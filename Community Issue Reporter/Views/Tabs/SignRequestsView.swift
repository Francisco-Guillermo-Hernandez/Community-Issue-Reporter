//
//  SignRequests.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI

struct User: Identifiable {
    let id: String?
    let username: String
    let avatar: String

    init(id: String? = nil, username: String, avatar: String) {
        self.id = UUID().uuidString as String?
        self.username = username
        self.avatar = avatar
    }
}

struct AvatarView: View {
    var user: User
    var body: some View {
        Image("user")
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipShape(.circle)
    }
}

struct Signatories: View {
    var users: [User]
    var body: some View {
        HStack(spacing: -.themeSpacing * 3) {
            ForEach(users) { user in
                AvatarView(user: user)
                    .overlay(
                        Circle().stroke(Color.theme.border, lineWidth: 1)
                    )
            }
        }
    }
}

struct PostPublisher: View {
    var body: some View {
        Group {
            HStack(alignment: .top, spacing: .themeSpacing * 3) {
                VStack {
                    Image("user_b")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .clipShape(.circle)
                }
                
                VStack {
                    Text("John Doe")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Yesterday at 20:20 - SS, SV")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PostInteractions: View {
    var sign: () -> Void
    var comment: () -> Void
    var share: () -> Void
    var body: some View {
        HStack {
            Button(action: sign) {
                Image(systemName: "signature")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .buttonSizing(.flexible)
            .frame(maxWidth: .infinity)

            Button(action: share) {
                Image(systemName: "text.bubble")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .buttonSizing(.flexible)
            .frame(maxWidth: .infinity)

            Button(action: share) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .buttonSizing(.flexible)
            .frame(maxWidth: .infinity)
        }
    }
}

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
    @State private var value: Double = 20

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

//        self.petitions = [
//            Petition(
//                id: "1",
//                title: "Hay un bache en la calle",
//                description: "un bache esta causando que los carros se dañen",
//                targetSignatures: 22,
//                currentSignatures: 0,
//                categoryId: 4,
//                statusId: 1,
//                reportedBy: UUID(
//                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
//                ),
//                disabled: false,
//                createdAt: Date(timeIntervalSince1970: 799056444.493906),
//                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
//                reportsIds: [
//                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
//                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
//                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
//                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
//                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
//                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
//                ]
//            ),
//            Petition(
//                id: "2",
//                title: "Un semaforo no esta funcionando en la avenida",
//                description: "",
//                targetSignatures: 22,
//                currentSignatures: 0,
//                categoryId: 4,
//                statusId: 1,
//                reportedBy: UUID(
//                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
//                ),
//                disabled: false,
//                createdAt: Date(timeIntervalSince1970: 799056444.493906),
//                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
//                reportsIds: [
//                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
//                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
//                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
//                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
//                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
//                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
//                ]
//            ),
//            Petition(
//                id: "3",
//                title: "Hay una fuga de agua en la colonia",
//                description: "",
//                targetSignatures: 22,
//                currentSignatures: 0,
//                categoryId: 4,
//                statusId: 1,
//                reportedBy: UUID(
//                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
//                ),
//                disabled: false,
//                createdAt: Date(timeIntervalSince1970: 799056444.493906),
//                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
//                reportsIds: [
//                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
//                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
//                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
//                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
//                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
//                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
//                ]
//            ),
//        ]

        //        self.petitions.append(contentsOf: petitions)

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
    
    @State private var level: Int = 20

    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: .themeSpacing * 4) {
                    headerView()

                    VStack(alignment: .leading, spacing: .themeSpacing * 2) {
                        //                        Text("Nearby Petitions")
                        //                            .font(.title3)
                        //                            .fontWeight(.semibold)
                        //                            .padding(.horizontal, .themePadding)

                        ForEach(petitions) { petition in
                            EventsOnDay(
                                petition: petition,
                                selectedIndex: petitions.firstIndex(where: {
                                    $0.id == petition.id
                                }) ?? 0
                            )
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
            }
            .background(Color.theme.background)
            .scrollContentBackground(.hidden)
            .refreshable {
                await fetchPetitions(reset: true)
            }
//            .toolbar(removing: .sidebarToggle)
            .navigationSplitViewColumnWidth(600)
            .customToolBar(
                isPrimaryActionVisible: isPrimaryActionVisible,
                title: title,
                subtitle: subtitle
            ) {

            } trailing: {

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
        } detail: {

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
            CreateRequestPetitionView(model: model)
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
            Text("  ")
                .font(.title.bold())
                .onGeometryChange(for: Bool.self) {
                    let height = abs($0.size.height - 5)
                    let offset = $0.frame(in: .global).minY
                    return -offset > height
                } action: { newValue in
                    title = newValue ? "Petitions" : nil
                }

            Text("**125** Petitions   **5.6K** signatories")
                .font(Font.headline)
                .foregroundColor(.secondary)

        }
        .padding(.horizontal, .themePadding)
        .padding(.bottom, .themePadding)
    }

    @ViewBuilder
    func EventsOnDay(petition: Petition, selectedIndex: Int) -> some View {

        VStack(alignment: .leading, spacing: 16) {
            Text(petition.title)
                .font(.title2)
                .fontWeight(.black)
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

            NavigationLink(destination: PetitionDetailView(petition: petition)) {

                VStack(spacing: .themeSpacing) {
                    RequestViewPost(petition: petition)
                        .clipShape(Rectangle())
                        .scrollClipDisabled(true)
                }
            }

            Divider()
            
            Gauge(value: value, in: 0...100) {
                Text("Signatures")
                    .font(.caption)
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
                
                PostInteractions(sign: {}, comment: {}, share: {})

            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(.theme.foreground)
        .overlay(
            Rectangle()
                .stroke(Color.theme.border, lineWidth: 1)
        )
        .background(Color.theme.cardBackground)

    }
}

struct RequestViewPost: View {
    var petition: Petition
    @State private var photos: [PhotoSample] = [
        PhotoSample(id: "1", photo: "a", published: Date(), user: "Jane Doe"),
        PhotoSample(id: "2", photo: "b", published: Date(), user: "John Smith"),
        PhotoSample(
            id: "3",
            photo: "c",
            published: Date(),
            user: "Michael Brown"
        ),
        PhotoSample(
            id: "4",
            photo: "d",
            published: Date(),
            user: "Emily Davis"
        ),
    ]
    var body: some View {

        VStack(spacing: 10) {
            PostPublisher()
                
            HStack(alignment: .top) {

                VStack(alignment: .leading) {
                    Text("Category")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(getCategoryName(id: petition.categoryId))
                }

                
                VStack(alignment: .leading) {
                    Text("Status")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(petition.status.title)
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: gridColumns, spacing: 16) {
                        ForEach(photos, id: \.id) { photo in

                            Image(photo.photo)
                                .resizable()
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .topLeading
                                )
                                .aspectRatio(4 / 3, contentMode: .fill)
                                .clipped()
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: .themeRadius,
                                        style: .continuous
                                    )
                                )
                                .contentShape(
                                    RoundedRectangle(
                                        cornerRadius: .themeRadius,
                                        style: .continuous
                                    )
                                )
                        }
                    }
                }
            }
            .frame(maxHeight: 200)

        }
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
