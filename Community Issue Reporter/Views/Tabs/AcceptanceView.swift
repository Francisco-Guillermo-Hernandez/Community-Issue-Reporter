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

struct LegalDocument: Identifiable {
    let id = UUID()
    let url: URL
    let documentName: String
}

struct AcceptanceView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedURLItem: URLItem?
    @State private var accepted: Bool = false
    
    @State private var legalLinks: [LegalDocument] = [
        LegalDocument(
            url: URL(
                string: "https://reportamelo.app/legal/eula"
            )!,
            documentName: String(
                localized: "EULA"
            )
        ),
        LegalDocument(
            url: URL(
                string: "https://reportamelo.app/legal/terms"
            )!,
            documentName: String(
                localized: "Terms"
            )
        ),
        LegalDocument(
            url: URL(
                string: "https://reportamelo.app/legal/privacy"
            )!,
            documentName: String(
                localized: "Privacy"
            )
        ),
        LegalDocument(
            url: URL(
                string: "https://reportamelo.app/legal/policies"
            )!,
            documentName: String(
                localized: "Policies"
            )
        )
    ]
    
    @State private var buttonMessage: String = String(localized: "Next")
    
    
    var nextStep: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text(String(localized: "Legal Documents"))
                    .font(Font.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.bold)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text(String(localized: "We take your privacy seriously, \nplease take time to read our documents."))
                    .font(.callout)
                    .foregroundColor(.primary)
                    .opacity(0.85)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                List(legalLinks) { link in
                    Button(action: {
                        selectedURLItem = URLItem(url: link.url)
                    }) {
                        HStack {
                            Text(link.documentName)
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(uiColor: .tertiaryLabel))
                        }
                    }
                }
                .scrollDisabled(true)
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
                        Text(String(localized: "I have read and accept the documents"))
                            .foregroundColor(.primary)
                            .font(.callout)
                        Spacer()
                    }
                    .padding()
                    .background(colorScheme == .dark ? .black.opacity(0.321) : .white.opacity(0.95))
                    .cornerRadius(16)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 36)
                .sensoryFeedback(.selection, trigger: accepted)
                
            }
        }
        .background {
            ZStack(alignment: .top) {
                GeometryReader { geo in
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.theme.secondary.mix(with: colorScheme == .dark ? .black : .white, by: 0.4).opacity(0.67),
                            Color.theme.background
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: geo.size.width * 0.54
                    )
                    
                }
            }
            .ignoresSafeArea()
        }
        .background(Color.theme.background)
        .sheet(item: $selectedURLItem) { item in
            SafariWebView(.constant(item.url))
                .ignoresSafeArea(edges: [.bottom, .top])
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
        
            
            ThemedButton(
                message: buttonMessage,
                action: {
                    nextStep()
                },
                type: .secondary
            )
            .disabled(!accepted)
            .padding(.horizontal, 36)
            .padding(.top, 0)
            .padding(.bottom, 4)
        }
    }
}

#Preview {
    AcceptanceView() {
        
    }
}
