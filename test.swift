import SwiftUI
@_spi(Experimental) import RevenueCatAdMob
struct MyAdView: View {
    var body: some View {
        NativeAdView(adUnitID: "ca-app-pub-3940256099942544/3986624511", request: Request())
    }
}
