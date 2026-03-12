//
//  CustomAlert.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 10/3/26.
//

import SwiftUI

@ViewBuilder
func CustomAlert(message: String, type: AlertType = .success) -> some View {
    ZStack {
        HStack(spacing: 16) {
            Image(systemName: type.icon)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(.horizontal, 12)
        .frame(minWidth: 100, maxWidth: 250)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
}

enum AlertType: String, CaseIterable, Identifiable {
    case success =  "checkmark.circle.fill"
    case notice = "exclamationmark.triangle.fill"
    case error =  "xmark.octagon.fill"
    
    var id: String { self.rawValue }
    var icon: String { self.rawValue }
}


struct CustomizedTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .scaleEffect(phase.isIdentity ? 1 : 0)
    }
}
