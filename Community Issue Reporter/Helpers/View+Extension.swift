//
//  View+Extension.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/3/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func optionalGlassEffect(_ colorScheme: ColorScheme, cornerRadius: CGFloat = 30) -> some View {
        let backgroundColor = colorScheme == .dark ? Color.black : Color.white
        
        if #available(iOS 26, *) {
            self
                .glassEffect(.clear.tint(backgroundColor.opacity(0.75)).interactive(), in: .rect(cornerRadius: cornerRadius, style: .continuous))
        } else {
            self
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(backgroundColor)
                }
        }
    }
    
    @ViewBuilder
    func optionalGlassWithShape(_ colorScheme: ColorScheme, shape: some Shape) -> some View {
        let backgroundColor = colorScheme == .dark ? Color.black : Color.white
        
        if #available(iOS 26, *) {
            
            self
                .glassEffect(.clear.tint(backgroundColor.opacity(0.45)).interactive(), in: shape)
        } else {
            self
                .background {
                    shape
                        .fill(backgroundColor)
                }
        }
    }
}

// MARK: - Extension to transform a View to a UIImage
extension View {
    func asImage() -> UIImage? {
        let controller = UIHostingController(
            rootView: self.edgesIgnoringSafeArea(.all)
        )
        let view = controller.view

        let targetSize = CGSize(width: 200, height: 200)  // Fixed size for avatars
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(
                in: CGRect(origin: .zero, size: targetSize),
                afterScreenUpdates: true
            )
        }
    }
}


extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}

// MARK: - Extension to re-enable interactive pop gesture when navigation bar is hidden
private struct EnableInteractivePopGesture: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        InteractivePopViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private class InteractivePopViewController: UIViewController, UIGestureRecognizerDelegate {
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return (navigationController?.viewControllers.count ?? 0) > 1
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

extension View {
    func enableInteractivePopGesture() -> some View {
        background(EnableInteractivePopGesture())
    }
}

