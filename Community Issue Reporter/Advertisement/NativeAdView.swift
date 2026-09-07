import SwiftUI
import GoogleMobileAds
@_spi(Experimental) import RevenueCatAdMob

public struct AdMobNativeAdView: UIViewControllerRepresentable {
    public let adUnitID: String
    
    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }
    
    public func makeUIViewController(context: Context) -> NativeAdViewController {
        let controller = NativeAdViewController()
        controller.adUnitID = adUnitID
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: NativeAdViewController, context: Context) {
        /// Not used for this case
    }
}

public class NativeAdViewController: UIViewController, NativeAdLoaderDelegate {
    var adUnitID: String!
    private var adLoader: AdLoader!
    private var nativeAdView: GoogleMobileAds.NativeAdView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Native Ad View
        nativeAdView = GoogleMobileAds.NativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nativeAdView)
        
        NSLayoutConstraint.activate([
            nativeAdView.topAnchor.constraint(equalTo: view.topAnchor),
            nativeAdView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nativeAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nativeAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Simple UI elements for the Native Ad
        let headlineLabel = UILabel()
        headlineLabel.font = .boldSystemFont(ofSize: 18)
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let mediaView = GoogleMobileAds.MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        
        let adBadge = UILabel()
        adBadge.text = " Ad "
        adBadge.font = .systemFont(ofSize: 11, weight: .bold)
        adBadge.textColor = .white
        adBadge.backgroundColor = .systemOrange
        adBadge.layer.cornerRadius = 3
        adBadge.clipsToBounds = true
        adBadge.translatesAutoresizingMaskIntoConstraints = false
        
        let callToActionButton = UIButton(type: .system)
        callToActionButton.backgroundColor = .systemBlue
        callToActionButton.setTitleColor(.white, for: .normal)
        callToActionButton.layer.cornerRadius = 8
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        nativeAdView.addSubview(iconView)
        nativeAdView.addSubview(adBadge)
        nativeAdView.addSubview(headlineLabel)
        nativeAdView.addSubview(bodyLabel)
        nativeAdView.addSubview(mediaView)
        nativeAdView.addSubview(callToActionButton)
        
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.iconView = iconView
        nativeAdView.callToActionView = callToActionButton
        nativeAdView.mediaView = mediaView
        
        NSLayoutConstraint.activate([
            // Icon
            iconView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 8),
            iconView.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: 8),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            // Ad badge
            adBadge.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            adBadge.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: 8),
            adBadge.heightAnchor.constraint(equalToConstant: 16),
            
            // MediaView
            mediaView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -8),
            mediaView.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: 8),
            mediaView.widthAnchor.constraint(equalToConstant: 120),
            mediaView.heightAnchor.constraint(equalToConstant: 120),
            
            // Headline
            headlineLabel.leadingAnchor.constraint(equalTo: adBadge.trailingAnchor, constant: 4),
            headlineLabel.trailingAnchor.constraint(equalTo: mediaView.leadingAnchor, constant: -8),
            headlineLabel.centerYAnchor.constraint(equalTo: adBadge.centerYAnchor),
            
            // Body
            bodyLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            bodyLabel.trailingAnchor.constraint(equalTo: mediaView.leadingAnchor, constant: -8),
            bodyLabel.topAnchor.constraint(equalTo: adBadge.bottomAnchor, constant: 4),
            bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: callToActionButton.bottomAnchor),
            
            // CTA
            callToActionButton.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -8),
            callToActionButton.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor, constant: -8),
            callToActionButton.widthAnchor.constraint(equalToConstant: 100),
            callToActionButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // Load Ad
        adLoader = AdLoader(
            adUnitID: adUnitID,
            rootViewController: self,
            adTypes: [.native],
            options: nil
        )
        adLoader.delegate = self
        
        // Using standard Request
        adLoader.load(Request())
    }
    
    public func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        // Populate view
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        nativeAdView.nativeAd = nativeAd
    }
    
    public func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("Failed to load native ad: \(error.localizedDescription)")
    }
}
