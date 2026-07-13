//
//  PreviewImageToUpload.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/6/26.
//

import SwiftUI
import Foundation

struct PreviewImageToUpload: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var name: String
    var phase: ImagePhase
    var data: UIImage?
    @Binding var currentValue: Float
    var total: Float
    var delete: (String) -> Void
    var retry: (String) -> Void
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            if let imageData = data {
                Image(uiImage: imageData)
                    .resizable()
                    .clipped()
                    .scaledToFit()
                    .blur(radius: completed ? 0 : 4)
                    .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous))
                    .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous))
                    .overlay {
                       
                        ZStack(alignment: .bottomLeading) {
                            
                            RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous)
                            
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            .init(color: .black.opacity(0.75), location: 0),
                                            .init(color: .black.opacity(0.2), location: 0.5),
                                            .init(color: .clear, location: 1)
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {

                                Text(phase.description)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.85))
                                    .padding(.bottom, 4)
                                    .animatedDots(animate: animateDots)
                                
                                
                                if !completed && phase != .success {
                                    ProgressView(value: currentValue, total: total)
                                        .shimmering()
                                }
                                
                            }
                            .padding()
                        }
                    }
            }
            
            
            
            if phase != .failure {
                Button {
                    delete(name)
                } label: {
                    Image(systemName: "xmark")
                        .symbolRenderingMode(.multicolor)
                }
                .buttonBorderShape(.circle)
                .buttonStyle(.glass)
                .padding(8)
                .disabled(phase == .deleting)
            } else {
                Button {
                    retry(name)
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.title2)
                        .opacity(0.86)
                }
                .padding(8)
            }
        }
    }
    
    private var animateDots: Bool {
        phase == .uploading || phase == .deleting
    }
    
    private var completed: Bool {
        currentValue == total
    }
    
    private var borderColor: Color {
        if colorScheme == .dark {
            // dark:border-input
            return Color.theme.inputBorder
        } else {
            // border
            return Color.theme.border
        }
    }
}


struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0.0
    
    var duration: Double = 1.5
    var shimmerColor: Color = .white.opacity(0.5)
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, shimmerColor, .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    // Scale the width of the shimmer to be roughly half the view width
                    .frame(width: geo.size.width * 0.5)
                    // Move it from left (completely off-screen) to right (completely off-screen)
                    .offset(x: -geo.size.width * 0.5 + (geo.size.width * 1.5 * phase))
                }
            )
            // Mask the overlay so it only clips to the visible parts of the ProgressView
            .mask(content)
            .onAppear {
                withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                    phase = 1.0
                }
            }
    }
}

// Extension for cleaner syntax
extension View {
    func shimmering(duration: Double = 1.5, color: Color = .white.opacity(0.5)) -> some View {
        self.modifier(ShimmerModifier(duration: duration, shimmerColor: color))
    }
}
