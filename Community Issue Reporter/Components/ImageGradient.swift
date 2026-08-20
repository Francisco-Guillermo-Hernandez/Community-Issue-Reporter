//
//  ImageGradient.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 19/8/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ImageGradient: View {
    var image: UIImage?
    var count: Int = 4
    var animation: Animation? = .none
    /// Use this to image extract colors for some other UI purposes!
    var onFinished: ([Color]) -> () = { _ in }
    /// View Properties
    @State private var colors: [Color] = []
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
            )
            .onAppear {
                guard let image else { return }
                updateFor(image: image)
            }
            .onChange(of: image) { oldValue, newValue in
                guard let newImage = newValue else { return }
                updateFor(image: newImage)
            }
    }
    
    private func updateFor(image: UIImage) {
        /// Use Dispatch Queue UserInteractive Mode, if you wish so!
        let downsizedImage = downsize(image: image)
        let colors = extractColors(image: downsizedImage)
        if let animation, !self.colors.isEmpty {
            withAnimation(animation) {
                self.colors = colors
            }
        } else {
            self.colors = colors
        }
        
        onFinished(colors)
    }
    
    /// Downsizing Image into max Dimension of 200!
    private func downsize(image: UIImage) -> UIImage {
        let maxDimension: CGFloat = 200
        let imageSize = image.size
        let scale = maxDimension / max(imageSize.width, imageSize.height)
        let newSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        
        let renderFormat = UIGraphicsImageRendererFormat()
        renderFormat.scale = 1
        
        return UIGraphicsImageRenderer(size: newSize, format: renderFormat).image { _ in
            image.draw(in: .init(origin: .zero, size: newSize))
        }
    }
    
    /// Extracting Dominant Colors
    private func extractColors(image: UIImage) -> [Color] {
        guard let ciImage = CIImage(image: image) else { return [] }
        
        let extent = ciImage.extent
        let tileHeight = extent.height / CGFloat(count)
        let context = CIContext()
        
        var colors: [Color] = []
        
        for index in 0..<count {
            let cropRect = CGRect(
                x: extent.origin.x,
                y: extent.height - CGFloat(index + 1) * tileHeight,
                width: image.size.width,
                height: tileHeight
            )
            
            let filter = CIFilter.areaAverage()
            filter.inputImage = ciImage
            filter.extent = cropRect
            guard let outputImage = filter.outputImage else { continue }
            
            /// Extracting Color
            var bytes = [UInt8](repeating: 0, count: 4)
            context.render(
                outputImage,
                toBitmap: &bytes,
                rowBytes: 4,
                bounds: .init(x: 0, y: 0, width: 1, height: 1),
                format: .RGBA8,
                colorSpace: CGColorSpaceCreateDeviceRGB()
            )
            
            let color = Color(
                red: CGFloat(bytes[0]) / 255,
                green: CGFloat(bytes[1]) / 255,
                blue: CGFloat(bytes[2]) / 255,
                opacity: CGFloat(bytes[3]) / 255
            )
            
            colors.append(color.inverted.opacity(0.6))
        }
        
        colors.append(Color.theme.background)
        
        return colors
    }
}

extension Color {
    var inverted: Color {
        // Bridge to UIColor to easily read components
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        // Extract RGBA values
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return self // Fallback to original color if extraction fails
        }
        
        // Invert channels and build the new SwiftUI Color
        return Color(
            red: Double(1.0 - r),
            green: Double(1.0 - g),
            blue: Double(1.0 - b),
            opacity: Double(a)
        )
    }
}
