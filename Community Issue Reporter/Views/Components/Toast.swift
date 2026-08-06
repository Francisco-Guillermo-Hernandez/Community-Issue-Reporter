import SwiftUI
import Observation

public enum ToastType {
    case error
    case info
    case warning
    case success
    
    var iconName: String {
        switch self {
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
    
    var tintColor: Color {
        switch self {
        case .error: return .red
        case .info: return .blue
        case .warning: return .orange
        case .success: return .green
        }
    }
}

@Observable
public class Toast {
    public static let shared = Toast()
    
    var message: String = ""
    var type: ToastType = .info
    var isShowing: Bool = false
    
    private init() {}
    
    @MainActor
    public func show(message: String, type: ToastType = .info) {
        self.message = message
        self.type = type
        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
            self.isShowing = true
        }
        
        Task {
            try? await Task.sleep(for: .seconds(3))
            await hide()
        }
    }
    
    @MainActor
    public func hide() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
            self.isShowing = false
        }
    }
}

struct ToastView: View {
    @State private var toast = Toast.shared
    @Environment(\.colorScheme) private var scheme
    private var isDark: Bool { scheme == .dark }
    
    var body: some View {
        VStack {
            if toast.isShowing {
                HStack(spacing: 12) {
                    Image(systemName: toast.type.iconName)
                        .foregroundStyle(toast.type.tintColor)
                        .font(.system(size: 20))
                    
                    Text(toast.message)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(isDark ? .white : .black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    glassBackground
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.9)),
                    removal: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.9))
                ))
                .onTapGesture {
                    Task {
                        await toast.hide()
                    }
                }
            }
            Spacer()
        }
        .padding(.top, 50)
        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: toast.isShowing)
        .ignoresSafeArea()
        .zIndex(100)
    }
    
    @ViewBuilder
    private var glassBackground: some View {
        Capsule()
            .fill(.ultraThinMaterial)
            .overlay(
                Capsule()
                    .fill(isDark ? Color.black.opacity(0.45) : Color.white.opacity(0.35))
            )
            .overlay(
                Capsule()
                    .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
            )
    }
}

public struct ToastModifier: ViewModifier {
    public func body(content: Content) -> some View {
        ZStack {
            content
            ToastView()
        }
    }
}

public extension View {
    func withToast() -> some View {
        self.modifier(ToastModifier())
    }
}
