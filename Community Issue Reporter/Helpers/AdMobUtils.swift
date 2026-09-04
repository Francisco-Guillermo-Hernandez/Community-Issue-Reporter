import Foundation
import GoogleMobileAds

func checkAdMobDomainStatus(completion: @escaping (Bool, Error?) -> Void) {
    guard let url = URL(string: "https://doubleclick.net") else {
        completion(false, nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "HEAD" // Use HEAD to minimize data usage
    request.timeoutInterval = 5.0
    
    let task = URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
            // Domain is likely blocked, offline, or restricted by a DNS/VPN/firewall
            completion(false, error)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, (200...499).contains(httpResponse.statusCode) {
            // Domain is reachable
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }
    task.resume()
}

// Ensure the delegate method is handled appropriately, this might need to be placed 
// inside an existing delegate class or view modifier depending on project structure.
//
// func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//    let nsError = error as NSError
//    if nsError.domain == "com.google.admob" {
//        print("AdMob error code: \(nsError.code)")
//        print("Description: \(nsError.localizedDescription)")
//        // Code 1 often means "No ad to show" or network/server unreachable restrictions
//    }
// }
