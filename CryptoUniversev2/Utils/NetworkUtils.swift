import Foundation

func generateNonce() -> Int64 {
    let current_time_milliseconds = Int64(Date().timeIntervalSince1970 * 1000)
    return current_time_milliseconds + 1
}

