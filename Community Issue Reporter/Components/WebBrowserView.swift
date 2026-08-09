import SwiftUI
import WebKit
import Observation

// private var domains = ["https://reportamelo.app/", "://reportamelo.app/"]

@Observable
class WebViewModel {
    let webView = WKWebView()
}

struct WebBrowserView: View {
    @Binding var url: URL?
    @State private var viewModel = WebViewModel()
    @Environment(\.dismiss) private var dismiss
    
    init(url: Binding<URL?>, viewModel: WebViewModel = WebViewModel()) {
        self._url = url
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                WebViewRepresentable(webView: viewModel.webView, url: url)
            }
            .ignoresSafeArea(edges: [.bottom, .top])
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(url?.host ?? String(localized: "Website"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .close) {
                        dismiss()
                    }
                    .accessibilityIdentifier("CloseWebViewButton")
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.webView.goBack()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .accessibilityIdentifier("GoBackButton")
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    
                    ShareLink(item: url!) {
                        Image(systemName: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                    }
                    
                    Button(action: {
                        viewModel.webView.reload()
                    }) {
                        Image(systemName: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                    }
                    .accessibilityIdentifier("ReloadButton")
                    
                    Button(action: {
                        UIApplication.shared.open(url!)
                    }) {
                        Image(systemName: "safari")
                        .frame(maxWidth: .infinity)
                    }
                    .accessibilityIdentifier("OpenInSafariButton")
                }
            }
        }
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    let webView: WKWebView
    let url: URL?
    
    init(webView: WKWebView, url: URL?) {
        self.webView = webView
        if let url {
            self.url = url
        } else {
            self.url = URL(string: "https://reportamelo.app/")
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil && !uiView.isLoading {
            let request = URLRequest(url: url!)
            uiView.load(request)
        }
    }
}

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    // 1. Pass the URL as a SwiftUI state/binding dependency
    let url: URL

    // 2. Create the UIKit view instance
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    // 3. Update the UIKit view when SwiftUI state changes
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

// Usage in SwiftUI
struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://reportamelo.app/")!)
            .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    WebBrowserView(url: .constant(URL(string: "https://reportamelo.app/")!))
}
