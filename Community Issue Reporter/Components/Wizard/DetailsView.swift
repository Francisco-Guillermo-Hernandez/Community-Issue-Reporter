//
//  DetailsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

struct DetailsView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Your Name", text: $name)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Your Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                    .frame(height: 80)
                    .padding(6)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                if description.isEmpty {
                    Text("Describe what happened...")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
        }
        .padding(.top, 4)
    }
}


#Preview {
    DetailsView(name: .constant(""), email: .constant(""), description: .constant(""))
}
