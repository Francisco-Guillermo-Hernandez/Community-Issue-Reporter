//
//  SearchView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/3/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let onSubmit: () -> Void
    let onFocusChange: (Bool) -> Void
    let onUserProfileTap: () -> Void
    @FocusState.Binding var isFocused: Bool
    let profileNamespace: Namespace.ID

    var body: some View {
        
        VStack {
            HStack() {
                HStack() {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                        .padding(.leading, 16)
                    
                    TextField("Search...", text: $text)
                        .textInputAutocapitalization(.words)
                        .modifier(ClearButtonModifier(text: $text, isPill: true))
                        .disableAutocorrection(true)
                        .padding(.vertical, 12)
                        .focused($isFocused)
                        .onSubmit(onSubmit)
                        .onChange(of: isFocused) { _, newValue in
                            onFocusChange(newValue)
                        }
                }
                .glassEffect()
                .animation(
                    .interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0),
                    value: isFocused
                )
                
                HStack {
                    if isFocused {
                        Button {
                            isFocused = false
                            text = ""
                        } label: {
                            ZStack {
                                Group {
                                    if #available(iOS 26, *) {
                                        Image(systemName: "xmark")
                                            .frame(width: 48, height: 48)
                                            .glassEffect(in: .circle)
                                    } else {
                                        Image(systemName: "xmark")
                                            .frame(width: 48, height: 48)
                                            .background(.ultraThinMaterial, in: .circle)
                                    }
                                }
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary)
                                .transition(.blurReplace)
                            }
                        }
                    } else {
                        Button {
                            onUserProfileTap()
                        } label: {
                            Text("FH")
                                .font(.title2.bold())
                                .frame(width: 48, height: 48)
                                .foregroundStyle(.white)
                                .background(.gray, in: .circle)
//                                .transition(.blurReplace)
                        }
                        .matchedTransitionSource(id: "openProfile", in: profileNamespace)
                    }
                }
            }
        }
       
    }
}
