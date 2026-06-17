//
//  View+Modifier.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/4/26.
//

import SwiftUI

// MARK: - view modifier to personalize the cells of a List {}
struct CellViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.theme.foreground)
            .padding()
            .background(Color.theme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                    .stroke(Color.theme.border, lineWidth: 1)
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(
                    top: 4,
                    leading: 16,
                    bottom: 4,
                    trailing: 16
                )
            )
            .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
            .glassEffect( in: RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
    }
}


struct SimpleCellViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.theme.foreground)
//            .padding(0)
//            .listRowSpacing(0)
            
//            .padding()
//            .background(Color.theme.cardBackground)
            .listRowBackground(Color.clear)
//            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(
                    top: 16,
                    leading: 0,
                    bottom: 16,
                    trailing: 0
                )
            )
            
    }
}

extension View {
    func cellStyle() -> some View {
        self.modifier(CellViewModifier())
    }
    
    func simpleCellStyle() -> some View {
        self.modifier(SimpleCellViewModifier())
    }
}

// MARK: - end


#Preview {
    @Previewable
    @State var sanSalvador: FriendlyCityDistribution = .init(
        cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
        firstLevel: "El Salvador",
        secondLevel: "San Salvador",
        thirdLevel: "San Salvador",
        ZipCode: "1101",
        legalGroupName: "Distrito de San Salvador",
        coordinates: .init(lat: 13.701270, lng: -89.224432),
        isCapitalCity: 1,
        isDepartmentalCapital: 1
    )
    
    return NavigationStack {
      
        ScrollView {
            LazyVStack(spacing: .themeSpacing * 4) {
                CityCellView(city: sanSalvador)
                    .cellStyle()
            }
            .padding(.horizontal, 16)
           
        }
        .background(Color.theme.background)
       
    }
}


#Preview("Simple cell") {
    ScrollView {
        List {
            HStack {
                Text("Reported by:")
                    .font(.caption)
                    .fontWeight(.semibold)
                Spacer()
                Text("John Doe")
                    .font(.caption)
            }
            .simpleCellStyle()
            
            HStack {
                Text("Reported by:")
                    .font(.caption)
                    .fontWeight(.semibold)
                Spacer()
                Text("Jane Doe")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .simpleCellStyle()
        }
        .environment(\.defaultMinListRowHeight, 0)
//        .overlay {
//            Rectangle()
//                .stroke(Color.black, lineWidth: 1)
//        }
        .padding()
        .listRowBackground(Color.clear)
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
    //    .listStyle(.insetGrouped)
        .listStyle(.plain)
        .scrollClipDisabled(true)
        .frame(height: 335)
        .contentMargins(.all, 0, for: .scrollContent)
    }
    .frame(maxWidth: .infinity)
    .background(Color.theme.primary)
}
