//
//  PulseRingView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/3/26.
//

import SwiftUI

struct PulseRingView: View {
    var tint: Color
    var size: CGFloat
 
    @State private var animate: [Bool] = [false, false, false]
    @State private var showView: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            if showView {
             
                ZStack {
                   ForEach(0..<3) { index in
                       ringView(index: index)
                    }
                }
            }
        }
        .onChange(of: scenePhase, initial: true) { oldValue, newValue in
         
            showView = newValue != .background
            
            if showView {
                startAnimation()
            } else {
                resetAnimation()
            }
        }
        .onAppear {
            showView = true
            startAnimation()
        }
        .onDisappear {
            showView = false
            resetAnimation()
        }
        .frame(width: size, height: size)
    }
    
    private func startAnimation() {

        for index in 0..<animate.count {
            let delay = Double(index) * 0.2
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false).delay(delay)) {
                animate[index] = true
            }
        }
    }
    
    private func resetAnimation() {
     
        animate = [false, false, false]
    }
    
    @ViewBuilder
    private func ringView(index: Int) -> some View {
        Circle()
            .fill(tint)
            .opacity(animate[index] ? 0 : 0.4)
            .scaleEffect(animate[index] ? 2 : 0)
    }
}
