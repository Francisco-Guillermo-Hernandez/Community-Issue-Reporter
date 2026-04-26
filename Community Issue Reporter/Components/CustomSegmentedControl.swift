//
//  CustomSegmentedControl.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/4/26.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Namespace private var segmentedControl
    @State private var state: CameraActions = .takePhoto
    
    var body: some View {
        HStack {
            ForEach(CameraActions.allCases) { state in
                Button {
                    withAnimation {
                        self.state = state
                    }
                } label: {
                    Text(state.description)
                        .foregroundStyle(Color.white)
                        .font(Font.body.bold())
                        .padding(.themeSpacing * 3)
                }
            
                .matchedGeometryEffect(
                    id: state,
                    in: segmentedControl
                )
            }
        }
        .background(
            Capsule()
                .fill(Color.init(hex: "f68322"))
                .matchedGeometryEffect(
                    id: state,
                    in: segmentedControl,
                    isSource: false
                )
        )
        .padding(.vertical, 4)
        .padding(.horizontal, .themeSpacing)
        .background(Color.init(hex: "222222"))
        .clipShape(
            Capsule()
        )
        .buttonStyle(.plain)
    }
}

#Preview {
    
    CustomSegmentedControl()
}
