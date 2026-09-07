//
//  SuggestionsResultList.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI
import GoogleMobileAds
@_spi(Experimental) import RevenueCatAdMob

struct SuggestionsResultList: View {
    
    @Environment(SubscriptionManager.self) var subscriptionManager
    @Binding var searchText: String
    @State var searchCompleter: SearchCompleter
    var applySuggestion: (SearchSuggestion) -> Void
    var body: some View {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            Text(String(localized: "Start typing to search."))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if searchCompleter.suggestions.isEmpty {
            ContentUnavailableView.search(text: String(localized: "No matches found."))
        } else {
            List {
                ForEach(Array(searchCompleter.suggestions.enumerated()), id: \.element.id) { index, suggestion in
                    Button {
                        applySuggestion(suggestion)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "mappin")
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
//                                .background(.thinMaterial, in: .circle)
                                .transition(.blurReplace)
                                .symbolColorRenderingMode(.gradient)
                            
//                                .symbolRenderingMode(.multicolor)
//                                                    .symbolColorRenderingMode(.gradient)
//                                                    .font(.system(size: 30))
                                                    .foregroundColor(.secondary)
                            
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
                    .listRowBackground(Color.clear)
                    
                    if !subscriptionManager.isPro, AdBackoffUtils.shouldShowAd(at: index) {
                        if let adUnitID = Bundle.main.object(forInfoDictionaryKey: "ADMOB_NATIVE_AD_UNIT") as? String, !adUnitID.isEmpty {
                            AdMobNativeAdView(adUnitID: adUnitID)
                                .frame(height: 220)
                                .padding(.horizontal)
                                .padding(.bottom, .themeSpacing * 4)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

//#Preview {
//    
//}
//
//
