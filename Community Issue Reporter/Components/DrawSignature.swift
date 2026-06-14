//
//  DrawSignature.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 11/6/26.
//

import SwiftUI

struct SignatureLine: Identifiable, Codable {
    let id: UUID
    var points: [CGPoint]
    
    init(id: UUID = UUID(), points: [CGPoint] = []) {
        self.id = id
        self.points = points
    }
}

struct DrawSignature: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var strokes: [SignatureLine]
    @State private var currentStroke = SignatureLine()
    var body: some View {
        
        NavigationStack {
            VStack {
                Canvas { context, size in
                    // Draw all completed strokes
                    for stroke in strokes {
                        var path = Path()
                        path.addLines(stroke.points)
                        context.stroke(path, with: .color(.primary), lineWidth: 3.0)
                    }
                    // Draw the line actively being drawn
                    var currentPath = Path()
                    currentPath.addLines(currentStroke.points)
                    context.stroke(currentPath, with: .color(.primary), lineWidth: 3.0)
                }
                .background(Color(.systemBackground))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newPoint = value.location
                            currentStroke.points.append(newPoint)
                        }
                        .onEnded { _ in
                            if !currentStroke.points.isEmpty {
                                strokes.append(currentStroke)
                                currentStroke = SignatureLine() // Reset for next stroke
                            }
                        }
                )
            }
            
       
            
            .toolbar {
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("", systemImage: "pencil.and.scribble") {
                        
                    }
                    
                    Button("clear signature", systemImage: "eraser.line.dashed") {
                        strokes.removeAll()
                        currentStroke = SignatureLine()
                    }
                }
                
        
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    
                }
                
                ToolbarItem(placement: .automatic) {
                    Button("Save signature") {
                        if let encoded = try? JSONEncoder().encode(strokes) {
                            UserDefaults.standard.set(encoded, forKey: "saved_signature")
                        }
                        dismiss()
                    }
                }
            }
            
        }
        
    }
    
    
}


struct SignatureAnimatedPlayer: View {
    let strokes: [SignatureLine]
    @State private var drawingProgress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<strokes.count, id: \.self) { index in
                Path { path in
                    path.addLines(strokes[index].points)
                }
                .trim(from: 0, to: strokeProgress(for: index))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
        }
        .task {
            // Replay the signature animation smoothly when the view presents
            withAnimation(.easeInOut(duration: 1.8)) {
                drawingProgress = 1.0
            }
        }
    }
    
    // Calculates how much of a specific stroke should be visible
    // based on the total global progress.
    private func strokeProgress(for index: Int) -> CGFloat {
        let totalStrokes = CGFloat(strokes.count)
        guard totalStrokes > 0 else { return 0 }
        
        let strokeWeight = 1.0 / totalStrokes
        let startBound = CGFloat(index) * strokeWeight
        let endBound = startBound + strokeWeight
        
        if drawingProgress >= endBound { return 1.0 }
        if drawingProgress <= startBound { return 0.0 }
        
        return (drawingProgress - startBound) / strokeWeight
    }
}

struct PreviewSignatureView: View {
    var petitionName: String
    @State var strokes: [SignatureLine] = []
    @State private var isCreating: Bool = false
    @State private var tempStrokes: [SignatureLine] = []
    
    var onSignature: () -> Void
    var body: some View {
       NavigationStack {
           VStack(alignment: .leading) {
               
               VStack(alignment: .leading) {
                   Text("Saved signature")
                       .font(Font.headline.bold())
                   
                   HStack(spacing: .themeSpacing * 2) {
                       
                       Button {
                           tempStrokes = strokes
                           isCreating.toggle()
                       } label: {
                           RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                               .frame(width: 100, height: 100)
                               .overlay {
                                   Image(systemName: strokes.isEmpty ? "plus" : "pencil")
                                       .font(.system(size: 40))
                                       .foregroundStyle(Color.theme.primary)
                               }
                       }
                       .buttonStyle(.plain)
                   }
               }
   //            .sheet(isPresented: $isCreating, onDismiss: {
   //                loadSignature()
   //            }) {
   //                DrawSignature(strokes: $tempStrokes)
   //            }
               
               if !strokes.isEmpty {
                   SignatureAnimatedPlayer(strokes: strokes)
                       .background(Color.theme.cardBackground)
                       .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
                       .glassEffect(in: RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
                       .padding(.top, 20)
               }
               
               ThemedButton(message: "Sign", action: onSignature, type: .primary, style: .prominent)
                   .padding(.top, .themePadding)
           }
           .padding()
           .toolbar {
               ToolbarItem(placement: .cancellationAction) {
                   Button(role: .close) {
                       
                   }
               }
           }
           .navigationSubtitle(petitionName)
           .navigationTitle(String(localized: "Petition to sign"))
           .navigationBarTitleDisplayMode(.inline)
           .task {
               loadSignature()
           }
        }
    }
    
    func loadSignature() {
        if let data = UserDefaults.standard.data(forKey: "saved_signature"),
           let decoded = try? JSONDecoder().decode([SignatureLine].self, from: data) {
            strokes = decoded
        } else {
            strokes = []
        }
    }
}

#Preview("Preview signature") {
    NavigationStack {
        
        Text("Hello")
            .sheet(isPresented: .constant(true)) {
                PreviewSignatureView(petitionName: "Installation of new lamps") {
                    
                }
            }
    }
}

#Preview {
    
    @Previewable
    @State var strokes: [SignatureLine] = []
    DrawSignature(strokes: $strokes)
}
