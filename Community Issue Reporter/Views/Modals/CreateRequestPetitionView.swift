//
//  CreateRequestPetition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 28/3/26.
//

import SwiftUI

struct CreateRequestPetitionView: View {

    @Environment(\.dismiss) private var dismiss
    @Bindable var controller: PetitionController
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
                            isValid: $controller.isTitleValid,
                            value: $controller.petition.title
                       )
                    
                       TextInput(
                            name: String(localized: "Description"),
                            label: String(localized: "Please enter a description"),
                            validators: descriptionValidator,
                            isValid: $controller.isDescriptionValid,
                            value: $controller.petition.description
                       )
                    }
                    
                    Picker("Category", selection: $controller.petition.category) {
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
                    .onChange(of: controller.petition.category) { oldValue, newValue in
                      
                        if oldValue != newValue {
                            let signatures = newValue.minimunAmountOfSignatures
                               controller.minimumSignatures = signatures
                            controller.petition.targetSignatures = signatures
                        }
                        
                    }
                } header: {
                    Text("Details of the request")
                }
                
                
                Section {
                    NavigationLink(
                        destination: ReportsChooserView(reports: controller.reports, selectedReports: $controller.petition.reportsIds)) {
                      HStack {
                          Text("Choose report(s)")
                          
                          Spacer()
                          
                          if !controller.petition.reportsIds.isEmpty {
                              SelectedDocumentsBadgeView(count: controller.petition.reportsIds.count)
                          } else {
                              Image(systemName: "document.badge.plus")
                          }
                      }
                  }
                } header: {
                     Text("Reports")
                }
                
                Section {
                    Stepper(value: $controller.petition.targetSignatures, in: controller.minimumSignatures...1000, step: 1) {
                        AnimatedText(text: "\( controller.petition.targetSignatures)")
                    }
                    .onChange(of: controller.petition.targetSignatures) { oldValue, newValue in
                    
                        if newValue > oldValue {
                            controller.stepperAction = "Increase"
                        } else if newValue < oldValue {
                            controller.stepperAction = "Decrease"
                        }
                    }
                    .sensoryFeedback(.increase, trigger: controller.petition.targetSignatures) { oldValue, newValue in
                        return newValue > oldValue
                    }
                    .sensoryFeedback(.decrease, trigger: controller.petition.targetSignatures) { oldValue, newValue in
                        return newValue < oldValue
                    }
//                    
                } header: {
                    Text("Set the amount of signatures needed")
                } footer: {
                    Text("The minimum amount of signatures depends of the category. For the choosen category, the minimun amount of signatures is \(controller.minimumSignatures) ")
                }
        
            }
            .background(Color.theme.background)
            .scrollContentBackground(.hidden)
            .task {
                /// Let's cancel the task if the user change the view
                guard !Task.isCancelled else { return }
                
                /// list reports for the creation of the petition
                await controller.fetchReports()
        
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
                        controller.isSubmitting.toggle()
                        
                       
                        
                        Task {
                          
                            do {
                               _ = try await PetitionRepository.share.create(controller.petition)
                                
                                onCompletion("Petition created", .info)
                                dismiss()
                                
                            } catch {
                                onCompletion("Petition created", .info)
                                dismiss()
                            }
                                
                            controller.isSubmitting.toggle()
                        }
//                        
                    } label: {
                        if controller.isSubmitting {
                            ProgressView()
                               .progressViewStyle(.circular)
                       } else {
                           Label("Submit", systemImage: "checkmark")
                       }
                    }
                    .disabled(controller.isSubmitting)
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

    @Previewable @State var controller = PetitionController()
   
    CreateRequestPetitionView(controller: controller, onCompletion: { _, _ in
        print("completed")
        print(controller.petition.title)
        print(controller.petition.targetSignatures)
    })
}
