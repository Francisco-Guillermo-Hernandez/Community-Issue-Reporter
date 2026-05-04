//
//  CustomToolBar.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func customToolBar<Leading: View, Trailing: View, PrimaryAction: View>(
        isPrimaryActionVisible: Bool,
        navBackButtonHidden: Bool = true,
        title: String?,
        subtitle: String?,
        @ViewBuilder leading: @escaping () -> Leading,
        @ViewBuilder trailing: @escaping () -> Trailing,
        @ViewBuilder primaryAction: @escaping () -> PrimaryAction
    ) -> some View {
        self
            .modifier(
                CustomToolBarModifier(
                    isPrimaryActionVisible: isPrimaryActionVisible,
                    navBackButtonHidden: navBackButtonHidden,
                    title: title,
                    subtitle: subtitle,
                    leading: leading,
                    trailing: trailing,
                    primaryAction: primaryAction
                )
            )
    }
}


fileprivate struct CustomToolBarModifier<Leading: View, Trailing: View, PrimaryAction: View>: ViewModifier {
    var isPrimaryActionVisible: Bool
    var navBackButtonHidden: Bool
    var title: String?
    var subtitle: String?
    @ViewBuilder var leading: Leading
    @ViewBuilder var trailing: Trailing
    @ViewBuilder var primaryAction: PrimaryAction
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    leading
                }
                
                ToolbarItem(placement: .title) {
                    Text(emptyLargeString)
                        .overlay(alignment: .leading) {
                            VStack(alignment: .leading, spacing: subtitle == nil ? 0 : 2) {
                                if let title {
                                    Text(title)
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .transition(.offset(y: 10).combined(with: AnyTransition(.blurReplace)))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("Petitions")
                                        .font(Font.largeTitle.bold())
                                        .frame(maxWidth: .infinity, alignment: .leading)
//
                                }
                                
                                ZStack {
                                    if let subtitle {
                                        Text(subtitle)
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                            .contentTransition(.numericText())
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .opacity(subtitle == nil ? 0 : 1)
                            }
                            .compositingGroup()
                            .geometryGroup()
                        }
                        .lineLimit(1)
                        .animation(.easeInOut(duration: 0.3), value: title)
                        .animation(.easeInOut(duration: 0.3), value: subtitle)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    trailing
                }
                
                if isPrimaryActionVisible {
                    ToolbarItem(placement: .topBarTrailing) {
                        primaryAction
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(navBackButtonHidden)
            /// Primary action Animation!
            .animation(.bouncy(duration: 0.3, extraBounce: 0), value: isPrimaryActionVisible)
    }
    
    private var emptyLargeString: String {
        String(repeating: " ", count: 50)
    }
}
