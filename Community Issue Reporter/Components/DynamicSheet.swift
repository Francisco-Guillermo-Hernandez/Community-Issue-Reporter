//
//  DynamicSheet.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/5/26.
//

import SwiftUI

// MARK: - Custom SheetHeader to be used with the custom SheetView
struct SheetHeaderView: View {
    let title: String
    let onClose: () -> Void
    var body: some View {
        HStack {
            Button(role: .close, action: onClose) {
               Image(systemName: "xmark")
                    .font(.system(size: 23, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .lineHeight(.multiple(factor: 1.5))
                    .padding(.all, 4)
           }
           .buttonBorderShape(.circle)
           .contentShape(.circle)
           .buttonStyle(.glass)
           .frame(maxWidth: 45)
           
           Text(title)
                .font(.headline)
               .frame(maxWidth: .infinity)
               .foregroundStyle(.primary)
            
           Spacer()
               .frame(maxWidth: 45)
        }
    }
}

// MARK: - Custom sheet

/// Kept for backward compatibility, but no longer used by DynamicSheet itself.
struct DynamicSheetLockPreference: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

extension View {
    func lockDynamicSheet(_ isLocked: Bool) -> some View {
        preference(key: DynamicSheetLockPreference.self, value: isLocked)
    }
}

struct DynamicSheet<Content: View>: View {
    var animation: Animation
    var isLocked: Bool = false
    @ViewBuilder var content: Content
    @State private var sheetHeight: CGFloat = 0

    var body: some View {
        ZStack {
            content
                /// As this will fix the size of the view in the vertical direction!
                .fixedSize(horizontal: false, vertical: true)
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { newValue in
                    guard newValue.height > 50 else { return }
                    guard !isLocked else { return }
                    let newHeight = min(newValue.height, windowSize.height - 110)
                    if abs(sheetHeight - newHeight) > 0.5 {
                        if sheetHeight == .zero {
                            /// Customize it according to your needs!
                            sheetHeight = newHeight
                        } else {
                            withAnimation(animation) {
                                sheetHeight = newHeight
                            }
                        }
                    }
                }
        }
        .modifier(SheetHeightModifier(height: sheetHeight))
    }
    
    /// You can use property to limit the max height, but I'm using the window size height to do so!
    var windowSize: CGSize {
        if let size = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size{
            return size
        }
        
        return .zero
    }
}

fileprivate struct SheetHeightModifier: ViewModifier {
    var height: CGFloat
    func body(content: Content) -> some View {
        content
            .presentationDetents(height == .zero ? [.medium] : [.height(height)])
            .presentationBackgroundInteraction(.enabled(upThrough: .height(height)))
    }
}

