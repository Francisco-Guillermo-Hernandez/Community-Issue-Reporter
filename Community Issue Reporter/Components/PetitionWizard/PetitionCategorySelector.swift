//
//  PetitionCategorySelector.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/7/26.
//

import SwiftUI


struct SelectOption: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedCategory: Categories
    var category: Categories
    var onTap: (() -> Void)? = nil
    
    private var isSelected: Bool {
        category == selectedCategory
    }
    
    init (_ category: Categories, _ selectedCategory: Binding<Categories>, _ onTap: (() -> Void)? = nil) {
        self.category = category
        self._selectedCategory = selectedCategory
        self.onTap = onTap
    }
    
    var body: some View {
        Text(category.title)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: 36)
            .fontWeight(isSelected ? .medium : .regular)
            .foregroundStyle(getForegroundColor())
            .background(getBackgroundColor(), in: .capsule)
            .glassEffect(.regular.interactive(), in: .capsule)
            .contentShape(.capsule)
            .font(.system(size: 14))
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                selectedCategory = category
                onTap?()
            }
        
    }
    
    private func getBackgroundColor() -> Color {
        if colorScheme == .dark {
            return isSelected ? Color.theme.cardForeground : Color.clear
        } else {
            return isSelected ? Color.init(hex: "38271F") : Color.white
        }
    }
    
    private func getForegroundColor() -> Color {
        if colorScheme == .dark {
            return Color.white
        } else {
            return isSelected ? Color.white : Color.theme.foreground
        }
    }
}

struct PetitionCategorySelector: View {
    @Binding var selected: Categories
    var onTap: (() -> Void)?
    var body: some View {
        
        VStack(alignment: .leading) {
            LabelView(
                text: String(localized: "Select a category"),
                isDisabled: false
            )
            
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 140), spacing: 12)],
                alignment: .leading,
                spacing: 12
            ) {
                ForEach(Categories.allCases, id: \.self) { category in
                    if category != .all {
                        SelectOption(category, $selected, onTap)
                            .accessibilityIdentifier(category.rawValue)
                            .accessibilityLabel(category.title)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(localized: "Select a category"))
    }
}

#Preview {
    @Previewable
    @State var selected: Categories = .corrective
    ScrollView(.vertical) {
        PetitionCategorySelector(selected: $selected)
    }
    .background(Color.theme.cardBackground)
}
