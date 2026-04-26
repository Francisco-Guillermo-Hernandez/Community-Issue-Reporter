//
//  ReportView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/2/26.
//

import SwiftUI
import UIKit
import MapKit

struct Option: Hashable {
    var icon: String
    var text: String
}

struct ReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var model: ReportDataModel
    @State private var issueType: IssueTypes
    @State private var severityLevel: Severity
    @State private var address: String
    @State private var coordinate: Coordinate
    @State private var descriptionText: String
    @State private var showDiscardAlert: Bool
    @State private var isSubmitting: Bool
    @State private var selectedImages: [MediaResources] = []
    @State private var showMapPickerSheet: Bool
    @State private var title: String = ""
    @State private var locator: Locator
    @Binding var showCancelButton: Bool
  
    init(model: ReportDataModel, onCompletion: @escaping (String, AlertType) -> Void, showCancelButton: Bool = false) {
        self.model = model
        self.issueType = .all
        self.severityLevel = .low
        self.address = ""
        self.coordinate = .init(lat: 13.6929, lng: -89.2182)
        self.descriptionText = ""
        self.showDiscardAlert = false
        self.isSubmitting = false
        self.selectedImages = []
        self.showMapPickerSheet = false
        self.locator = .init(countryCode: "", country: "", region: "", city: "")
        self.onCompletion = onCompletion
        self._showCancelButton = Binding<Bool>(get: { showCancelButton }, set: { _ in })
    }
    
    var onCompletion: (String, AlertType) -> Void
    
    private var isFormFilled: Bool {
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || !selectedImages.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                /// This section is dedicated to select a location on the map
                Section("Location") {
                    MiniMapLocator(coordinate: $coordinate, onExpandMap: { coordinate in
                        self.coordinate = coordinate
                        showMapPickerSheet.toggle()
                    })
                }
                
                /// This section is dedicated to select the evidence of the issue
                    Section("Photos") {
                    PhotoChooser(
                        onSelect: { images in
                            print("Selected images: \(images.count)")
                            self.selectedImages = images
                        },
                        onDelete: { index in
                            self.selectedImages.remove(at: index)
                        }
                    )
                
                    }
                
                ///
                Section("Issue Details") {
                    
                    Picker("Issue type", selection: $model.report.issueTypeId) {
                        ForEach(IssueTypes.allCases, id: \.self) { issue in
                            HStack(spacing: 80) {
                                Text(issue.title)
                                
                                Spacer()
                                Image(systemName: issue.iconName)
                                    
                            }
                            
                            .tag(issue)
                        }
                    }
                  

                    
                    Picker("Severity level", selection: $model.report.severityId) {
                        ForEach(Severity.allCases, id: \.self) { level in
                            HStack(spacing: 8) {
                               
                                Image(systemName: level.iconName)
                                    .padding(.trailing, 10)
                                Text(level.title)
                            }
                            .tag(level.title)
                            .tag(level)
                        }
                    }
                   
                }
                .padding(.horizontal, 8)
                
                ///
                Section("Details") {
                    

                    VStack {
                        TextInput(
                            name: "Title",
                            label: String(localized: "Title of the issue", comment: "ReportView: Title of the issue"),
                            value: $model.report.title,
                        )
                    
                        TextInput(
                            name: "Description",
                            label: String(localized: "Please describe the issue", comment: "ReportView: Please describe the issue"),
                            axis: .vertical,
                            value: $model.report.description,
                            
                        )
                        
                        TextInput(
                            name: "Address",
                            label: String(localized: "Please tell us where is the issue", comment: "ReportView: Please tell us where is the issue"),
                            axis: .vertical,
                            value: $address,
                            
                        )
                    }
                }
                
               
            }
            .navigationTitle("Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                if showCancelButton {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .close) {
                            if isFormFilled {
                                showDiscardAlert = true
                            } else {
                                dismiss()
                            }
                        }
                        .accessibilityLabel("Close")
                        .confirmationDialog("Are you sure...", isPresented: $showDiscardAlert)  {
                            
                            Button("Keep editing", role: .cancel) {
                                showDiscardAlert = false
                            }
                            Button("Discard changes", role: .destructive) {
                                dismiss()
                            }
                        } message: {
                            Text("You have unsaved information in this report.")
                        }
                    }
                }
                
                ToolbarItem(placement: .title) {
                    Text("Report a new issue")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isSubmitting = true
                        
                        Task {
                            let reportId = await ReportRepository
                                .create(
                                    report: Report(
                                        coordinate: self.coordinate,
                                        address: self.address,
                                        title: self.title,
                                        description: self.descriptionText,
                                        severityId: self.severityLevel.identifier,
                                        statusId: 1,
                                        issueTypeId: self.issueType.identifier,
                                        matterToSolveId: "",
                                        cellIndex: "demo",
                                        olc: "demo",
                                    ),
                                    locator: self.locator,
                                    onError: { error in
                                        print("error: \(error)")
                                    }
                                )
                            
                            if selectedImages.count > 0 {
                                print("there are images")
                                await ImageEncoderService().prepareAndSend(
                                    reportId: reportId,
                                    images: selectedImages
                                )
                            }
                            
                            await MainActor.run {
                                if reportId != "-1" {
                                    dismiss()
                                    onCompletion("Report submitted successfully.", .success)
                                } else {
                                    dismiss()
                                    onCompletion("Error submitting report.", .error)
                                }
                            }
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
            .interactiveDismissDisabled(isFormFilled)
        }
        .sheet(isPresented: $showMapPickerSheet)  {
            MapPickerView(coordinate: $coordinate, onConfirm: { coordinate, locator in
                self.coordinate = coordinate
                self.locator = locator
                self.address = self.locator.address
                
                print("coordinate \(self.coordinate.lat), \(self.coordinate.lng)")
                print("locator \(self.locator)")
                print("address \(self.address)")
                self.showMapPickerSheet = false
            })
        }
    }

   
}



#Preview {
    var model: ReportDataModel = ReportDataModel()
    model.setMatterToSolve(mattersToResolve.first!)
    return ReportView(model: model, onCompletion: { data, type in
        
    }, showCancelButton: true)
}
