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
    @State private var refreshID = UUID()
    @State private var petitions: [Petition] = []
    @State private var page: Int = 1
//    @State private var model: PetitionDataModel = PetitionDataModel.shared
    @Binding var path: [InsightsNavigation]

    var subViewName: String
    var body: some View {
        List {
            ForEach(petitions, id: \.id) { petition in
                NavigationLink(value: InsightsNavigation.petition(petition)) {
                    PetitionCellView(petition: petition)
                        .cellStyle()
                }
                .listRowInsets(themeCellEdgeInsets)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .background(Color.theme.background)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fetchPetitions() async {
        await PetitionRepository.share.list(q: PaginatedRequestQueryParams(page: 1, limit: 16), locator: Locator(countryCode: "", country: "", region: "", city: "", address: ""), onComplete: { result in

            guard let documents = result.documents else { return }
            petitions.append(contentsOf: documents)


        }, onError: { error in
            print(error)
        })
    }
}

#Preview {
    @Previewable
    @State var path: [InsightsNavigation] = []
    return MyPetitionsSubView(path: $path, subViewName: "My Petitions")
}
