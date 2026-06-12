//
//  PhotoDetailView.swift
//  Community Issue Reporter
//
//  Created by Antigravity on 11/6/26.
//

import SwiftUI

struct PhotoDetailView: View {
    let photos: [PhotoSample]
    @Binding var previewID: String
    let nameSpace: Namespace.ID
    
    @State private var currentIndex: Int
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    @Environment(\.dismiss) private var dismiss
    
    init(photos: [PhotoSample], previewID: Binding<String>, nameSpace: Namespace.ID) {
        self.photos = photos
        self._previewID = previewID
        self.nameSpace = nameSpace
        
        let initialIndex = photos.firstIndex(where: { $0.id == previewID.wrappedValue }) ?? 0
        self._currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        let currentPhoto = photos[currentIndex]
        
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    // Header custom toolbar
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                               .font(.title3)
                               .fontWeight(.semibold)
                               .foregroundColor(.white)
                               .padding(10)
                               .background(Color.white.opacity(0.15))
                               .clipShape(Circle())
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        Text("\(currentIndex + 1) / \(photos.count)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Dummy view to keep alignment centered
                        Color.clear
                            .frame(width: 44, height: 44)
                            .padding(.trailing)
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    // Image with DragGesture (Pan gesture)
                    Image(currentPhoto.photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: offset)
                        .opacity(opacity)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation.width
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 80
                                    if value.translation.width < -threshold {
                                        // Swipe Left -> Next Image
                                        if currentIndex < photos.count - 1 {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                offset = -screenWidth
                                                opacity = 0
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                currentIndex += 1
                                                previewID = photos[currentIndex].id
                                                offset = screenWidth
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    offset = 0
                                                    opacity = 1.0
                                                }
                                            }
                                        } else {
                                            // Bounce back (elastic effect)
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                offset = 0
                                            }
                                        }
                                    } else if value.translation.width > threshold {
                                        // Swipe Right -> Previous Image
                                        if currentIndex > 0 {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                offset = screenWidth
                                                opacity = 0
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                currentIndex -= 1
                                                previewID = photos[currentIndex].id
                                                offset = -screenWidth
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    offset = 0
                                                    opacity = 1.0
                                                }
                                            }
                                        } else {
                                            // Bounce back (elastic effect)
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                offset = 0
                                            }
                                        }
                                    } else {
                                        // Bounce back (elastic effect)
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            offset = 0
                                        }
                                    }
                                }
                        )
                    
                    Spacer()
                    
                    // Photo info overlay (User and published date)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentPhoto.user)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(currentPhoto.published.formatted(date: .long, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
