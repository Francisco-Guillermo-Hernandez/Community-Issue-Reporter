//
//  MyPetitionsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct PetitionCellView: View {
    var petition: Petition
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(petition.title)
                        .font(.title2)
                        .fontWidth(.condensed)
                        .fontWeight(.bold)
                        .lineLimit(1)

                    Text(petition.description)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, .themeSpacing)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MyPetitionsSubView: View {
    @State private var isLoading: Bool = false
    @State private var refreshID = UUID()
    @State private var petitions: [Petition] = []
    @State private var page: Int = 1
    //    @State private var model: PetitionDataModel = PetitionDataModel.shared
    @Binding var path: [InsightsNavigation]

    var subViewName: String
    var body: some View {
        Group {

            if isLoading {
                LoadingView()
            }

            if petitions.isEmpty && !isLoading {
                ContentUnavailableView {
                    Label("No petitions yet.", systemImage: "person.bubble")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            Color.theme.foreground.opacity(0.7),
                            Color.theme.primary,
                            Color.theme.foreground.opacity(0.7)
                        )
                } description: {
                    Text(
                        "Please create petitions in order to accelerate the process of ..."
                    )
                } actions: {

                }
                .containerRelativeFrame(.vertical)
            } else {
                List {
                    ForEach(petitions, id: \.id) { petition in
                        NavigationLink(
                            value: InsightsNavigation.petition(petition)
                        ) {
                            PetitionCellView(petition: petition)
                                .cellStyle()
                        }
                        .listRowInsets(themeCellEdgeInsets)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
        .task {
            guard !Task.isCancelled else { return }
            await fetchPetitions()
        }
        .listStyle(.plain)
        .navigationTitle(subViewName)
        .background(Color.theme.background)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fetchPetitions() async {
        isLoading = true

        let locator: Locator = .init()
        
        let query = PaginatedRequestQueryParams(page: 1, limit: 16)
        await PetitionRepository.share.list(
            q: query,
            locator: locator,
            onComplete: { result in

                guard let documents = result.documents else { return }
                petitions = documents

                isLoading = false
            },
            onError: { error in
                print(error)
                isLoading = false
            }
        )
    }
}

#Preview {
    @Previewable
    @State var path: [InsightsNavigation] = []
    return NavigationStack {
        MyPetitionsSubView(path: $path, subViewName: "My Petitions")
    }
}
