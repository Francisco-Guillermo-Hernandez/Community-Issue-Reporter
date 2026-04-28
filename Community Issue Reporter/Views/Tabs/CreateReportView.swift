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
    @State private var issueType: IssueTypes = .all
    @State private var severity: Severity = .all
    @State private var model = ReportDataModel.shared
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: Self.gridColumns, spacing: .themeSpacing * 3) {
                    ForEach(filteredMatters, id: \.id) { matter in
                        NavigationLink(destination: report(matter: matter)) {
                            CardView(matter: matter)
                        }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if show {
                    Group {
                        if #available(iOS 26, *) {
                            customAlert(message: message, type: type)
                                .transition(.asymmetric(insertion: .identity, removal: .opacity))
                                .optionalGlassEffect(colorScheme, cornerRadius: 16)
                        }
                    }
                    .offset(x: 0, y: -62)
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Picker("Issue Type", selection: $issueType) {
                            ForEach(IssueTypes.allCases, id: \.self) { issueType in
                                Text(issueType.title).tag(issueType.title)
                            }
                        }
                        Picker("Severity", selection: $severity) {
                            ForEach(Severity.allCases, id: \.self) { severity in
                                Text(severity.title).tag(severity.title)
                            }
                        }
                    } label: {
                        Label("Options", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }
            .padding(.horizontal)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle("Report")
            .navigationSubtitle("what do you want to report?")
        }
        
    }
    
    /// Open report view with type of matter chosen
    @ViewBuilder
    private func report(matter: MatterToSolve) -> some View {
        ReportView(model: model, onCompletion: { incomingMessage, alertType in
            message = incomingMessage
            type = alertType
            show = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                self.show = false
                
            }
        })
        .onAppear {
            model.setMatterToSolve(matter)
        }
    }
    
    private var filteredMatters: [MatterToSolve] {
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedQuery.isEmpty {
            return filterByIssueType(matter: filterByStatus(matter: mattersToResolve))
        }
        
        return mattersToResolve.filter { matter in
            matter.title.localizedCaseInsensitiveContains(trimmedQuery)
            || matter.description.localizedCaseInsensitiveContains(trimmedQuery)
            
        }
    }
    
    private func filterByStatus(matter: [MatterToSolve]) -> [MatterToSolve] {
        return matter.filter { matter in
            matter.severity == self.severity || self.severity == .all
        }
    }
    
    private func filterByIssueType(matter: [MatterToSolve]) -> [MatterToSolve] {
        return matter.filter { matter in
            matter.issueType == self.issueType || self.issueType == .all
        }
    }
    
    private static let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: .themeSpacing * 3),
        GridItem(.flexible(), spacing: .themeSpacing * 3)
    ]
}

// MARK: - CardView for the grid
struct CardView: View {
    var matter: MatterToSolve
    var body: some View {
        VStack {
            ZStack {
                
                if let icon = matter.icon, !icon.isEmpty {
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(12)
                }
                
                if let image = matter.image, !image.isEmpty {
                    Image(image)
                        .resizable()
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .aspectRatio(4/3, contentMode: .fill)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
                        .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
                }
                
                VStack(alignment: .leading, spacing: .themeSpacing * 1.5) {
                    Spacer()
                    Text(matter.title)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fontWeight(.black)
                        .lineLimit(2)
                        .padding(.themePadding)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle(color: matter.severity.color)
            }
        }
        
    }
    
    
    private static func colorIndex(for id: String) -> Int {
        abs(id.hashValue) % cardColors.count
    }
}

#Preview {
    CreateReportView()
}
