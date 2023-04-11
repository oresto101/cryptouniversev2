import Foundation

func saveDataToUserDefaults(key: String, data: [String: Double]) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
}
