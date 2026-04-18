//
//  CustomAlert.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 10/3/26.
//

import SwiftUI

@ViewBuilder
func customAlert(message: String, type: AlertType = .success) -> some View {    
    ZStack {
        HStack(spacing: 16) {
            Image(systemName: type.icon)
                .font(.system(size: 12))
                .foregroundStyle(type.color)
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
                .fixedSize()
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        
    }
    .allowsHitTesting(false)
}

enum AlertType: String, CaseIterable, Identifiable {
    case success =  "checkmark.circle.fill"
    case notice = "exclamationmark.triangle.fill"
    case error =  "xmark.octagon.fill"
    case info = "info.circle.fill"
    
    var id: String { self.rawValue }
    var icon: String { self.rawValue }
    
    var color: Color {
        switch self {
            case .success: return .green
            case .notice: return .yellow
            case .error: return .red
            case .info: return .blue
        }
    }
}


struct CustomizedTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .scaleEffect(phase.isIdentity ? 1 : 0)
    }
}
