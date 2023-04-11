import Foundation

public func saveDataToUserDefaults(key: String, data: [String: Double]) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
}

public func saveDataToUserDefaults(key: String, data: String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
}
