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
    var avatarURL: URL? = nil
    @ObservedObject var viewModel = ProfileDataModel()

    var body: some View {
        
        VStack {
            HStack() {
                HStack() {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                        .padding(.leading, 16)
                        .font(.system(size: 17, weight: .medium))
                        
                    
                    TextField("Search...", text: $text)
                        .font(.body)
                        .fontWeight(.medium)
                        .textInputAutocapitalization(.words)
                        .modifier(ClearButtonModifier(text: $text, isPill: true, disabled: false))
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
                            if let url = avatarURL ?? UserRepository.shared.getAvatar() ?? UserRepository.shared.getProfilePictureURL() {
                                CachedAsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
                                .id(url)

                                
                            } else {
                                Image("user_b")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())

                            }
                        }
                        .matchedTransitionSource(id: "openProfile", in: profileNamespace)
                    }
                }
            }
        }
       
    }
}
