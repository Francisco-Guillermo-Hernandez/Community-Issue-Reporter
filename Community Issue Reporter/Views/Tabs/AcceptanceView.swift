//
//  AcceptanceView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/8/26.
//

import SwiftUI

struct URLItem: Identifiable {
    let id = UUID()
    let url: URL
}

struct AcceptanceView: View {
    @State private var selectedURLItem: URLItem?
    @State private var accepted: Bool = false
    
    @State private var legalLinks: [URL] = [
        URL(string: "https://reportamelo.app/legal/eula")!,
        URL(string: "https://reportamelo.app/legal/terms")!,
        URL(string: "https://reportamelo.app/legal/privacy")!,
        URL(string: "https://reportamelo.app/legal/policies")!,
    ]
    
    @State private var buttonMessage: String = String(localized: "Next")
    
    
    var nextStep: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Legal Documents")
                .font(.title2)
                .bold()
                .padding(.top, 24)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            List(legalLinks, id: \.self) { link in
                Button(action: {
                    selectedURLItem = URLItem(url: link)
                }) {
                    HStack {
                        Text(link.lastPathComponent.capitalized)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color(uiColor: .tertiaryLabel))
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
            Button(action: {
                withAnimation(.snappy) {
                    accepted.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: accepted ? "checkmark.square.fill" : "square")
                        .foregroundColor(accepted ? .accentColor : .secondary)
                        .font(.title2)
                        .contentTransition(.symbolEffect(.replace))
                    Text("I have read and accept the documents")
                        .foregroundColor(.primary)
                        .font(.body)
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground).cornerRadius(10))
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .sensoryFeedback(.selection, trigger: accepted)
            
        }
        
        .background(Color.theme.background)
        .sheet(item: $selectedURLItem) { item in
            SafariWebView(.constant(item.url))
                .ignoresSafeArea(edges: [.bottom, .top])
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomFadedView {
                ThemedButton(
                    message: buttonMessage,
                    action: {
                        nextStep()
                    },
                    type: .primary
                )
                .padding()
                .padding(.top, 0)
            }
            .disabled(!accepted)
        }
    }
}

#Preview {
    AcceptanceView() {
        
    }
}
