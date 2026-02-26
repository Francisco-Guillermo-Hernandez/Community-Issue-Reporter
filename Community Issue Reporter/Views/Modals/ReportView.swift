//
//  ReportView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/2/26.
//

import SwiftUI

struct Option: Hashable {
    var icon: String
    var text: String
}

struct ReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var issueType: IssueTypes = .road
    @State private var severityLevel: Severity = .low
    @State private var location = ""
    @State private var descriptionText = ""
    @State private var showDiscardAlert = false

    private var isFormFilled: Bool {
        
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {

            Form {
                Section("Issue Details") {
                    
                    Picker("Issue type", selection: $issueType) {
                        ForEach(IssueTypes.allCases, id: \.self) { issue in
                            HStack(spacing: 8) {
                                Text(issue.title)
                                Image(systemName: issue.iconName)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .tag(issue)
                        }
                    }
                    
                    Picker("Severity level", selection: $severityLevel) {
                        ForEach(Severity.allCases, id: \.self) { level in
                            HStack(spacing: 8) {
                                Text(level.title).tag(level.title)
                                Image(systemName: level.iconName)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .tag(level)
                        }
                    }
                    
                }

                Section("Location") {
                    TextField("Address", text: $location)
                    
                }
                
                Section("Description") {
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 60)
                }

                Section("Photos") {
                    HStack(spacing: 12) {
                        Button {
                            // TODO: Hook up camera
                        } label: {
                            Label("Camera", systemImage: "camera")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(.secondary)

                        Button {
                            // TODO: Hook up photo picker
                        } label: {
                            Label("Gallery", systemImage: "photo.on.rectangle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                    }
                }
            }
            .navigationTitle("Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        if isFormFilled {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
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
                
                ToolbarItem(placement: .title) {
                    Text("Report a new issue")
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit", systemImage: "checkmark") {
                        // TODO: Hook up submit
                    }
                }
            }
            
        }
    }
}

#Preview {
    ReportView()
}
