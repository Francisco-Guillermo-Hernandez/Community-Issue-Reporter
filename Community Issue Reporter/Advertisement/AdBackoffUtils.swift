import Foundation

public struct AdBackoffUtils {
    /// Determines whether an advertisement should be shown at the given list index
    /// using an Inverse Exponential Backoff algorithm (e.g., indices 2, 6, 14, 30...)
    public static func shouldShowAd(at index: Int) -> Bool {
        var currentAdIndex = 2
        var currentGap = 4
        
        while currentAdIndex <= index {
            if index == currentAdIndex {
                return true
            }
            currentAdIndex += currentGap
            currentGap *= 2
        }
        
        return false
    }
}
