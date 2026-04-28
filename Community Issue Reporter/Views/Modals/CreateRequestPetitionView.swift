//
//  CreateRequestPetition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 28/3/26.
//

import SwiftUI

struct CreateRequestPetitionView: View {
    
    @Binding var model: PetitionDataModel
    @State var isSubmitting: Bool = false
    @State var title: String = ""
    @State var description: String = ""
    @State var category: Categories = .all
    @State var minimunSignatures: Int = 10
    @State var targetSignatures: Int = 10
    @State var stepperAction: String = ""
    @State var reports: [Report] = []
    @Environment(\.dismiss) private var dismiss
    
    
    init(model: Binding<PetitionDataModel>) {
        self._model = model
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    
                    VStack(alignment: .leading, spacing: 8) {
                       TextInput(
                            name: "Title",
                            label: "Please enter a title",
                            validators: titleValidator,
                            value: $model.petition.title
                       )
                    
                       TextInput(
                            name: "Description",
                            label: "Please enter a description",
                            validators: descriptionValidator,
                            value: $model.petition.description
                       )
                    }
                    
                    Picker("Category", selection: $model.petition.category) {
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
                    .onChange(of: model.petition.category) { oldValue, newValue in
                      
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
                    NavigationLink(destination: ReportsChooserView(reports: reports, selectedReports: $model.petition.reportsIds)) {
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
                        AnimatedText(text: "\(model.petition.targetSignatures)")
                    }
                    .onChange(of: model.petition.targetSignatures) { oldValue, newValue in
                        if newValue > oldValue {
                            stepperAction = "Increase"
                        } else if newValue < oldValue {
                            stepperAction = "Decrease"
                        }
                    }
                    .sensoryFeedback(.increase, trigger: (model.petition.targetSignatures != 0) && stepperAction == "Increase")
                    .sensoryFeedback(.decrease, trigger: (model.petition.targetSignatures != 0) && stepperAction == "Decrease")
                } header: {
                    Text("Set the amount of signatures needed")
                } footer: {
                    Text("The minimum amount of signatures depends of the category. For the choosen category, the minimun amount of signatures is \(minimunSignatures) ")
                }
        
            }
            .task {
                // Let's cancel the task if the user change the view
                guard !Task.isCancelled else { return }
                self.reports = await ReportRepository.shared.listReports(onError: { error in
                    print(error)
                })
            }
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
                                
                                    print(result)
                                    dismiss()
                                },
                                onError: { error in
                                    print(error)
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
    CreateRequestPetitionView(model: .constant(.shared))
}
