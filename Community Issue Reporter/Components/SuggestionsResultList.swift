//
//  SuggestionsResultList.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI

struct SuggestionsResultList: View {
    
    @Binding var searchText: String
    @State var searchCompleter: SearchCompleter
    var applySuggestion: (SearchSuggestion) -> Void
    var body: some View {
        List {
            let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                Text(String(localized: "Start typing to search."))
            } else if searchCompleter.suggestions.isEmpty {
                ContentUnavailableView.search(text: String(localized: "No matches found."))
            } else {
                ForEach(searchCompleter.suggestions) { suggestion in
                    Button {
                        applySuggestion(suggestion)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "mappin")
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                                .background(.thinMaterial, in: .circle)
                                .transition(.blurReplace)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(suggestion.title)
                                    .fontWeight(.semibold)
                                    .font(.title3)
                                
                                if !suggestion.subtitle.isEmpty {
                                    Text(suggestion.subtitle)
                                        .font(.caption)
                                    
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    
}


