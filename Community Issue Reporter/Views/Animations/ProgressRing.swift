//
//  ProgressRing.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 4/7/26.
//

import SwiftUI

struct ProgressRing: View {
    @Binding var progress: Double
    let color: Color
    let size: CGFloat
    let lineWidth: CGFloat
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(color, style: StrokeStyle(
                    lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(180))
            
//            Text(progressText)
//                .contentTransition(.numericText())
//                .animation(.default, value: progressText)
//                .font(.footnote)
//                .fontWidth(.compressed)

        }
        .frame(width: size, height: size)
        .task {
            withAnimation(.easeInOut(duration: 4)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            
            withAnimation(.bouncy) {
                animatedProgress = newValue
            }
        }
    }
    
    private var progressText: String {
        String(format: "%.0f%%", progress * 100)
    }
}

#Preview {
    @Previewable @State var progress: Double = 0.1
    @State var value: Double = 10
    var maxValue: Double {
        100.0
    }
    
    Button {
//        value += 10
//        progress = min(value / maxValue, 1)
        progress += 0.1
    } label: {
         Text("Increment")
    }
    
    
    //{
//    min(value / maxValue, 1)
//}
    
            ThemedButton(message: "Increment", action: {}, type: .primary)
    ZStack {
        Color.theme.primary
        ProgressRing(progress: $progress, color: .white, size: 30, lineWidth: 4.0)

    }
    .clipShape(.capsule)
    .frame(width: .infinity, height: 44)
}
