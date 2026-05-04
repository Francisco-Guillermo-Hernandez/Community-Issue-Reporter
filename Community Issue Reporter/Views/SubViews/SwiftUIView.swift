//
//  SwiftUIView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/4/26.
//

import SwiftUI
import PhotosUI

struct SwiftUIView: View {
    @State var selectedItems: [PhotosPickerItem] = []


    

        var body: some View {
            VStack {
                PhotosPicker(selection: $selectedItems,
                             matching: .any(of: [.images, .not(.screenshots)])) {
                    Text("Select Photos")
                }
            }
        }
}

#Preview {
   
}

