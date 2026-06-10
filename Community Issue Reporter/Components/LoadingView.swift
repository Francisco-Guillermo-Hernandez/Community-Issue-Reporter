//
//  LoadingView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 3/6/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.background)
        .containerRelativeFrame(.vertical)
    }
}

#Preview {
    LoadingView()
}
