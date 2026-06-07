//
//  ColorGrid.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/6/26.
//

import SwiftUI

// MARK: - Color Grid
struct ColorGrid: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedColor: Color
    var colors: [Color]

    var body: some View {
        LazyVGrid(columns: columns, spacing: .themeSpacing * 4) {
            ForEach(colors, id: \.self) { color in
                Circle()
//                    .fill(selectedColor == color ? color : color.mix(with: .white, by: 0.4))
                    .fill(color.opacity(isSelected(color) ? 1 : 0.75))
                    .scaleEffect(isSelected(color) ? 1.15 : 1)
                    .frame(width: 40, height: 40)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected(color))
                    .overlay {
                        if selectedColor == color {
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.theme.border, lineWidth: 2 )
                                
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.caption.bold())
                            }
                            
                        }
                        
                        
                    }
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
    
    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.fixed(40), spacing: 15),
            count: 6
        )
    }
    
    private func isSelected(_ color: Color) -> Bool {
        selectedColor == color
    }
}

struct MonogramView: View {
    var mode: MonogramMode = .preview
    var text: String
    var backgroundColor: Color
    var body: some View {
        ZStack {
            backgroundColor
            Text(text)
                .font(.system(size: mode == .preview ? 36 : 90, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(
            width: mode == .preview ? 80 : 200,
            height: mode == .preview ? 80 : 200
        )
        .clipShape(Circle())
    }
}

#Preview {
    @Previewable
    @ObservedObject var profile = ProfileDataModel()
    ColorGrid(selectedColor: .constant(.blue), colors: profile.backgroundColors)
}
