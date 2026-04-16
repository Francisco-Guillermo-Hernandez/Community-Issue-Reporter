//
//  SampleView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/2/26.
//

import SwiftUI

struct SampleView: View {
    @State private var isSingleShape: Bool = true
    @Namespace private var namespace
    
    var body: some View {
        GlassEffectContainer(spacing: 40) {
            Button(action: {
                
                withAnimation {
                    isSingleShape.toggle()
                }
                
            }, label: {
                Image(systemName: "leaf.fill")
                    .frame(width: 50.0, height: 50.0)
                    .font(.system(size: 26))
            })
            .glassEffectID("togglebutton", in: namespace)
            .buttonStyle(.glass)
            
            
            if !isSingleShape {
                
                VStack {
                    Image(systemName: "thermometer.sun.fill")
                        .frame(width: 80.0, height: 80.0)
                        .font(.system(size: 36))
                        .glassEffect()
                        .glassEffectID("thermometer", in: namespace)

                    Image(systemName: "humidity.fill")
                        .frame(width: 80.0, height: 80.0)
                        .font(.system(size: 36))
                        .glassEffect()
                        .glassEffectID("humidity", in: namespace)

                    Image(systemName: "wind")
                        .frame(width: 80.0, height: 80.0)
                        .font(.system(size: 36))
                        .glassEffect()
                        .glassEffectID("wind", in: namespace)
                }
                
                
//                List {
//                    ForEach(1...3, id: \.self) { index in
//                        Text("\(index)")
//                            .glassEffect()
//                            .glassEffectID(String("text\(index)"), in: namespace)
//                    }
//                    .glassEffect()
//                    .glassEffectID("list", in: namespace)
//                }
//                
//                HStack {
//                    Button { } label: { Image(systemName: "plus") }
//                        .glassEffect()
//                        .glassEffectID(String("texta"), in: namespace)
//                    Button { } label: { Image(systemName: "minus") }
//                        .glassEffect()
//                        .glassEffectID(String("textb"), in: namespace)
//                    Button { } label: { Image(systemName: "xmark")}
//                        .glassEffect()
//                        .glassEffectID(String("textv"), in: namespace)
//            
//                }
//                .glassEffect()
             //                    .glassEffectID("list", in: namespace)
            }
        }
    }
}

#Preview {
    SampleView()
}
