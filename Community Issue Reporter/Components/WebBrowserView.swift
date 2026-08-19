import SwiftUI
import WebKit
import Observation
import SafariServices

// private var domains = ["https://reportamelo.app/", "://reportamelo.app/"]

struct SafariWebView: UIViewControllerRepresentable {
    @Binding var url: URL?
    
    init(_ url: Binding<URL?> = .constant(URL(string: "https://reportamelo.app/"))) {
        self._url = url
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url!)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Leave empty for standard usage
    }
}


@Observable
class WebViewModel: NSObject, WKNavigationDelegate {
    let webView = WKWebView()
    
    override init() {
        super.init()
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if let host = url.host, host.contains("reportamelo.app") {
                decisionHandler(.allow)
                return
            } else if url.scheme == "http" || url.scheme == "https" {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.cancel)
    }
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


#Preview {
    WebBrowserView(url: .constant(URL(string: "https://reportamelo.app/")!))
}


struct SafariContentView: View {
    @State private var isBrowserPresented = false
    @State private var url: URL?
    
    init(url: URL?) {
        if let url {
            self.url = url
        } else {
            self.url = URL(string: "https://reportamelo.app/")!
        }
    }

    var body: some View {
        Button("Open Web View") {
            isBrowserPresented = true
        }
        .sheet(isPresented: $isBrowserPresented) {
            SafariWebView($url)
                .ignoresSafeArea(edges: [.bottom, .top])
        }
    }
}


#Preview {
    SafariContentView(url: URL(string: "https://reportamelo.app/")!)
}
