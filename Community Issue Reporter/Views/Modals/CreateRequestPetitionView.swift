//
//  CreateRequestPetition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 28/3/26.
//

import SwiftUI

struct CreateRequestPetitionView: View {

    @Environment(\.dismiss) private var dismiss
    @State var isSubmitting: Bool = false
    @State var minimunSignatures: Int = 10
    @State var stepperAction: String = ""
    @State var reports: [Report] = []
    @State private var targetSignatureValue = 10
 
    @State var reportsIds: [String] = []
    @ObservedObject var model: PetitionDataModel
    
    var onCompletion: (String, AlertType) -> Void
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    
                    VStack(alignment: .leading, spacing: 8) {
                       TextInput(
                            name: String(localized: "Title"),
                            label: String(localized: "Please enter a title"),
                            validators: titleValidator,
                            isValid: .constant(true),
                            value: $model.petition.title
                       )
                    
                       TextInput(
                            name: String(localized: "Description"),
                            label: String(localized: "Please enter a description"),
                            validators: descriptionValidator,
                            isValid: .constant(true),
                            value: $model.petition.description
                       )
                    }
                    
                    Picker("Category", selection: $model.petition.category) {
                        ForEach(Categories.allCases, id: \.self) {
                            if $0 == .all {
                                Text("Select a category").tag(0)
                                    .padding(4)
                            } else {
                                Text($0.title.capitalized).tag($0)
                                    .padding(4)
                            }
                        }
                    }
                    .onChange(of: model.petition.category) { oldValue, newValue in
                      
                        if oldValue != newValue {
                            let signatures = newValue.minimunAmountOfSignatures
                               self.minimunSignatures = signatures
                            model.petition.targetSignatures = signatures
                        }
                        
                    }
                } header: {
                    Text("Details of the request")
                }
                
                
                Section {
                    NavigationLink(
                        destination: ReportsChooserView(reports: reports, selectedReports: $model.petition.reportsIds)) {
                      HStack {
                          Text("Choose report(s)")
                          
                          Spacer()
                          
                          if !model.petition.reportsIds.isEmpty {
                              SelectedDocumentsBadgeView(count: model.petition.reportsIds.count)
                          } else {
                              Image(systemName: "document.badge.plus")
                          }
                      }
                  }
                } header: {
                     Text("Reports")
                }
                
                Section {
                    Stepper(value: $model.petition.targetSignatures, in: minimunSignatures...1000, step: 1) {
                        AnimatedText(text: "\( model.petition.targetSignatures)")
                    }
                    .onChange(of: model.petition.targetSignatures) { oldValue, newValue in
                    
                        if newValue > oldValue {
                            stepperAction = "Increase"
                        } else if newValue < oldValue {
                            stepperAction = "Decrease"
                        }
                    }
                    .sensoryFeedback(.increase, trigger: model.petition.targetSignatures) { oldValue, newValue in
                        return newValue > oldValue
                    }
                    .sensoryFeedback(.decrease, trigger: model.petition.targetSignatures) { oldValue, newValue in
                        return newValue < oldValue
                    }
                    
                } header: {
                    Text("Set the amount of signatures needed")
                } footer: {
                    Text("The minimum amount of signatures depends of the category. For the choosen category, the minimun amount of signatures is \(minimunSignatures) ")
                }
        
            }
            .background(Color.theme.background)
            .scrollContentBackground(.hidden)
            .task {
                // Let's cancel the task if the user change the view
                guard !Task.isCancelled else { return }
                
//                self.minimunSignatures = model.petition.category.minimunAmountOfSignatures
//                if model.petition.targetSignatures < minimunSignatures {
//                    model.petition.targetSignatures = minimunSignatures
//                }
                
                // list reports for the creation of the petition
                do {
                    let result = try await ReportRepository.shared.listByUser(page: 1)
                    guard let reports = result.documents else { return }
                    self.reports = reports
                    
                } catch {
                    print(error.localizedDescription)
                }
        
            }
            .background(Color.theme.background)
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .title) {
                    Text("Create Petition")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        isSubmitting.toggle()
                        
                        Task {
                          
                            
                            
                            await PetitionRepository.share.create(
                                model.petition,
                                onComplete: { result in
                                
                                    onCompletion("Petition created", .info)
                                    dismiss()
                                    
                                },
                                onError: { error in
                                    onCompletion("Error", .error)
                                    dismiss()
                                })
                                
                            
                            
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

    @Previewable
    @State var model = PetitionDataModel()
    CreateRequestPetitionView(model: model, onCompletion: { _, _ in
        print("completed")
        print(model.petition.title)
        print(model.petition.targetSignatures)
    })
}
