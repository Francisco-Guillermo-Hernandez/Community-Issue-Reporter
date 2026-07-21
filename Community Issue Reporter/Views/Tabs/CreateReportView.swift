//
//  CreateReportView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/3/26.
//

import SwiftUI

enum ReportNavigationDestination: Hashable {
    case reportWizard
    case reportLocation
    case attachMedia
    case addInformation
    case finalStep
}

// MARK: - View
struct CreateReportView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var model = ReportDataModel.shared
    @State private var controller = CreateReportController()
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .top) {
                Color.theme.background
                    .ignoresSafeArea()
                
                Color.orange
                    .opacity(0.12)
                    .frame(height: 280)
                    .mask(
                        LinearGradient(
                            colors: [.white, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blur(radius: 60)
                    .ignoresSafeArea()
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: Self.gridColumns, spacing: .themeSpacing * 3) {
                        
                        ForEach(controller.filteredMatters, id: \.id) { matter in
                            NavigationLink(destination: report(matter: matter)) {
                                CardView(matter: matter)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                controller.feedbackTrigger.toggle()
                            })
                        }
                    }
                }
                .sensoryFeedback(.selection, trigger: controller.feedbackTrigger)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Menu {
                            Picker("Issue Type", selection: $controller.issueType) {
                                ForEach(IssueTypes.allCases, id: \.self) { issueType in
                                    Text(issueType.title).tag(issueType.title)
                                }
                            }
                            Picker("Severity", selection: $controller.severity) {
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
                .searchable(text: $controller.searchText, prompt: "Search")
                .toolbar(.visible, for: .tabBar)
                .toolbarTitleDisplayMode(.inlineLarge)
                .navigationTitle("Report")
                .navigationSubtitle("what do you want to report?")
                .scrollContentBackground(.hidden)
             
            }
        }
    }
    
    /// Open report view with type of matter chosen
    @ViewBuilder
    private func report(matter: MatterToSolve) -> some View {
        ReportWizardContainer(model: model, onCompletion: { _, _ in
        })
        .task {
            model.clear()
            model.setMatterToSolve(matter)
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
               
                if let image = matter.image, !image.isEmpty {
                    Image(image)
                        .resizable()
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .aspectRatio(4/3, contentMode: .fill)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous))
                        .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous))
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
}

#Preview {
    CreateReportView()
}
