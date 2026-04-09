//
//  CreateReportView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/3/26.
//

import SwiftUI

struct CreateReportView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    @State private var message: String = ""
    @State private var type: AlertType = .success
    @State private var show = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: Self.gridColumns, spacing: 16) {
                    ForEach(filteredMatters, id: \.id) { matter in
                        NavigationLink(destination: self.description) {
                            CardView(matter: matter)
                        }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if show {
                    Group {
                        if #available(iOS 26, *) {
                            CustomAlert(message: message, type: type)
                                .transition(.asymmetric(insertion: .identity, removal: .opacity))
                                .optionalGlassEffect(colorScheme, cornerRadius: 16)
                        }
                    }
                    .offset(x: 0, y: -62)
                }
            }
            .padding(.horizontal)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle("Report")
            .navigationSubtitle("what do you want to report?")
        }
        
    }
    
    private var description: some View {
        
        
        ReportView(onCompletion: { incomingMessage, alertType in
            message = incomingMessage
            type = alertType
            show = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                self.show = false
                
            }
        })
    }
    
    private var filteredMatters: [MatterToSolve] {
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedQuery.isEmpty {
            return matterToResolve
        }
        return matterToResolve.filter { matter in
            matter.title.localizedCaseInsensitiveContains(trimmedQuery)
            || matter.description.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }
    
    
    private static let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
}

struct CardView: View {
    var matter: MatterToSolve
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(cardColors[Self.colorIndex(for: matter.id)])
                .frame(maxWidth: .infinity)
                .aspectRatio(1.45, contentMode: .fit)
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 6)
            
            if let icon = matter.icon, !icon.isEmpty {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Spacer()
                Text(matter.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(matter.description)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
        }
    }
    
    
    private static func colorIndex(for id: String) -> Int {
        abs(id.hashValue) % cardColors.count
    }
}

#Preview {
    CreateReportView()
}
