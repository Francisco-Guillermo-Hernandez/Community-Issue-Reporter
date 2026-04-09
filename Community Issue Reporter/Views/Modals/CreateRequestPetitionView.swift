//
//  CreateRequestPetition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 28/3/26.
//

import SwiftUI

struct CreateRequestPetitionView: View {
    
    @State var isSubmitting: Bool = false
    @State var title: String = ""
    @State var description: String = ""
    @State var category: Categories = .all
    @State var reportIds: [String] = []
    @State var minimunSignatures: Int = 10
    @State var targetSignatures: Int = 10
    @State var stepperAction: String = ""
    @State var selectedReportIds: [String] = []
    @State var reports: [Report] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    
                    VStack(alignment: .leading, spacing: 8) {
                       TextInput(
                            name: "Title",
                            label: "Please enter a title",
                            validators: titleValidator,
                            value: $title
                       )
                    
                       TextInput(
                            name: "Description",
                            label: "Please enter a description",
                            validators: descriptionValidator,
                            value: $description
                       )
                    }
                    
                    Picker("Category", selection: $category ) {
                        ForEach(Categories.allCases, id: \.self) {
                            if $0 == .all {
                                Text("Select a category").tag(0)
                                    .padding(4)
                            } else {
                                Text($0.rawValue.capitalized).tag($0)
                                    .padding(4)
                            }
                        }
                    }
                    .onChange(of: category) {  oldValue, newValue in
                       if oldValue != newValue {
                           let signatures = newValue.minimunAmountOfSignatures
                           self.minimunSignatures = signatures
                           self.targetSignatures = signatures
                        }
                    }
                } header: {
                    Text("Details of the request")
                }
                
                
                Section {
                    NavigationLink(destination: ReportsChooserView(reports: reports, selectedReports: $selectedReportIds)) {
                      HStack {
                          Text("Choose report(s)")
                          
                          Spacer()
                          
                          if !selectedReportIds.isEmpty {
                              SelectedDocumentsBadgeView(count: selectedReportIds.count)
                          } else {
                              Image(systemName: "document.badge.plus")
                          }
                      }
                  }
                } header: {
                     Text("Reports")
                }
                
                Section {
                    Stepper(value: $targetSignatures, in: minimunSignatures...1000, step: 1) {
                        AnimatedText(text: "\(targetSignatures)")
                    }
                    .onChange(of: targetSignatures) { oldValue, newValue in
                        if newValue > oldValue {
                            stepperAction = "Increase"
                        } else if newValue < oldValue {
                            stepperAction = "Decrease"
                        }
                    }
                    .sensoryFeedback(.increase, trigger: (targetSignatures != 0) && stepperAction == "Increase")
                    .sensoryFeedback(.decrease, trigger: (targetSignatures != 0) && stepperAction == "Decrease")
                } header: {
                    Text("Set the amount of signatures needed")
                } footer: {
                    Text("The minimum amount of signatures depends of the category. For the choosen category, the minimun amount of signatures is \(minimunSignatures) ")
                }
        
            }
//            .scrollContentBackground(.hidden)
//            .background(.ultraThinMaterial)
            .onAppear {
                Task {
                    self.reports = await ReportRepository.listReports()
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                
                ToolbarItem(placement: .title) {
                    Text("Create Petition")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isSubmitting.toggle()
                        
                        Task {
                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                            
                            isSubmitting.toggle()
                        }
                        
                    } label: {
                       if isSubmitting {
                            ProgressView()
                               .progressViewStyle(.circular)
                       } else {
                           Label("Submit", systemImage: "checkmark")
                       }
                    }
                    .disabled(isSubmitting)
                }
            }
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

struct SelectedDocumentsBadgeView: View {
    var count: Int
    var body: some View {
        Image(systemName: count == 1 ? "document" : "document.on.document")
            .overlay(
                ZStack {
                    Circle()
                        .fill(Color.red)
                    Text("\(count)")
                        .foregroundColor(.white)
                        .font(.caption2.bold())
                }
                .offset(x: 10, y: -10)
                .opacity(count > 0 ? 1 : 0)
            )
    }
}

struct AnimatedText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .contentTransition(.numericText())
            .animation(.default, value: text)
    }
}


#Preview {
    CreateRequestPetitionView()
}
