//
//  PhotoDetailView.swift
//  Community Issue Reporter
//
//  Created by Antigravity on 11/6/26.
//

import SwiftUI

struct PhotoDetailView: View {
    let photos: [PreviewAttachment]
    @Binding var previewID: String
    let nameSpace: Namespace.ID
    
    @State private var currentIndex: Int
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    @Environment(\.dismiss) private var dismiss
    
    init(photos: [PreviewAttachment], previewID: Binding<String>, nameSpace: Namespace.ID) {
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
            
            ZStack(alignment: .top) {
                Color.black
                    .ignoresSafeArea()
                
                PhotoPreview(currentPhoto, height: geometry.size.height * 0.70, width: geometry.size.width * 0.70)
                    .offset(x: offset)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height / 2)
                    .opacity(opacity)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation.width
                            }
                            .onEnded { value in
                                let threshold: CGFloat = 80
                                if value.translation.width < -threshold {
                                    /// Swipe Left -> Next Image
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
                                        /// Bounce back (elastic effect)
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            offset = 0
                                        }
                                    }
                                } else if value.translation.width > threshold {
                                    /// Swipe Right -> Previous Image
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
                                        /// Bounce back (elastic effect)
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            offset = 0
                                        }
                                    }
                                } else {
                                    /// Bounce back (elastic effect)
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        offset = 0
                                    }
                                }
                            }
                    )
                    .ignoresSafeArea()
                
                /// Header custom toolbar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                           .font(.title3)
                           .fontWeight(.semibold)
                           .foregroundColor(.white)
                           .padding(10)
                           .background(Color.black.opacity(0.4))
                           .clipShape(Circle())
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text("\(currentIndex + 1) / \(photos.count)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    /// Dummy view to keep alignment centered
                    Color.clear
                        .frame(width: 44, height: 44)
                        .padding(.trailing)
                }
                .padding(.top, 16)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
