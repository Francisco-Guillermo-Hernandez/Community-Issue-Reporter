//
//  CustomBar.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/7/26.
//

import SwiftUI

struct CustomTabBar: View {
    var items: [String]
    var searchHint: String = "Cities, Reports or petitions"
    @Binding var selection: String
    @Binding var searchText: String
    @Binding var isSearchExpanded: Bool
    var onSearchActivated: (Bool) -> ()
    var onLocationTap: (() -> Void)? = nil
    /// View Properties
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewSize: CGSize = .zero
    @FocusState private var isKeyboardActive: Bool
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                if !isSearchExpanded {
                    Button(action: {
                        onLocationTap?()
                    }) {
                        Image(systemName: "location.fill")
                            .frame(width: 45, height: 45)
                            .foregroundStyle(Color.primary)
                            .glassEffect(.regular.interactive(), in: .circle)
                            .contentShape(.circle)
                    }
                }
                
                ExpandableSearchBar()
                
                ForEach(items, id: \.self) { item in
                    ItemView(item)
                }
            }
            .padding(.horizontal, 16)
            /// Making it center of the screen when the search bar is expanded!
            .visualEffect { [isSearchExpanded] content, proxy in
                let rect = proxy.frame(in: .scrollView)
                
                return content
                    .offset(x: isSearchExpanded ? -rect.minX : 0)
            }
        }
        .frame(height: 50)
        .scrollDisabled(isSearchExpanded)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .animation(animation, value: selection)
        .animation(animation, value: isKeyboardActive)
        .onChange(of: isKeyboardActive) { oldValue, newValue in
            onSearchActivated(newValue)
        }
        .onGeometryChange(for: CGSize.self) {
            $0.size
        } action: { newValue in
            viewSize = newValue
        }
    }
    
    /// Item View
    @ViewBuilder
    private func ItemView(_ item: String) -> some View {
        let isSelected = selection == item
        let foregroundTint: Color = isSelected ? (colorScheme != .dark ? .white : .black) : .primary
        let backgroundTint: Color = isSelected ? (colorScheme == .dark ? .white : .black) : .clear
        
        let isFirst = items.first == item && isSearchExpanded
        
        ZStack {
            if isFirst {
                /// Minimize Button
                Image(systemName: "circle.grid.2x2.fill")
                    .frame(width: 60, height: 45)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .contentShape(.capsule)
                    .onTapGesture {
                        isKeyboardActive = false
                        withAnimation(animation) {
                            isSearchExpanded = false
                        }
                    }
                    .padding(.trailing, 12)
            } else {
                Text(item)
                    .padding(.horizontal, 15)
                    .frame(height: 45)
                    .foregroundStyle(foregroundTint)
                    .background(backgroundTint, in: .capsule)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .contentShape(.capsule)
                    .onTapGesture {
                        if selection == item {
                            selection = ""
                        } else {
                            selection = item
                        }
                    }
                    .disabled(isSearchExpanded)
            }
        }
    }
    
    /// Expandable Search bar
    @ViewBuilder
    private func ExpandableSearchBar() -> some View {
        /// 102: 12 Spacing from main View, 60 From the Minimize Button & horizontal Padding 30
        /// 12+60+30 = 102
        let fitSearchBarWidth: CGFloat = viewSize.width - 102
        
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .frame(width: isSearchExpanded ? 40 : 60)
            
            if isSearchExpanded {
                TextField(searchHint, text: $searchText)
                    .focused($isKeyboardActive)
            }
        }
        .padding(.leading, isSearchExpanded ? 5 : 0)
        .padding(.trailing, isSearchExpanded ? 15 : 0)
        .frame(height: 45)
        .clipShape(.capsule)
        .glassEffect(.regular.interactive(), in: .capsule)
        .contentShape(.capsule)
        .gesture(
            TapGesture(count: 1).onEnded { _ in
                withAnimation(animation) {
                    isSearchExpanded = true
                }
            },
            isEnabled: !isSearchExpanded
        )
        .padding(.trailing, isKeyboardActive ? 57 : 0)
        .background(alignment: .trailing) {
            Image(systemName: "xmark")
                .frame(width: 45, height: 45)
                .glassEffect(.regular.interactive(), in: .circle)
                .contentShape(.circle)
                .onTapGesture {
                    searchText = ""
                    isKeyboardActive = false
                }
                .opacity(isKeyboardActive ? 1 : 0)
        }
        .frame(width: isSearchExpanded ? fitSearchBarWidth : nil, alignment: .leading)
    }
    
    /// Update the animation according to your needs!
    private let animation: Animation = .interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0)
}

#Preview {
    @Previewable @State var selection: String = ""
    @Previewable @State var searchText: String = ""
    @Previewable @State var isSearchExpanded: Bool = false
    
    CustomTabBar(
        items: IssueStatus.allCases.map(\.title),
        searchHint: "",
        selection: $selection, searchText: $searchText, isSearchExpanded: $isSearchExpanded, onSearchActivated: {_ in }
    )
        .onChange(of: selection) { _, newValue in
            print(newValue)
        }
}
