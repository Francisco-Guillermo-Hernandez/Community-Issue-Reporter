//
//  CreateRequestPetition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 28/3/26.
//

import SwiftUI

struct CreateRequestPetitionView: View {
    
    @State var isSubmitting: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Create Petition")
            }
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        
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

#Preview {
    CreateRequestPetitionView()
}
