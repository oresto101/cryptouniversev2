import Foundation

public func removeManualHistoryRecord(key: String) {
    var manualHistory = UserDefaults.standard.double(forKey: "ManualHistoricData")
    if var manualHistoricDict = UserDefaults.standard.dictionary(forKey: "manualHistoricDict") as? [String: [Double]] {
        let valueToRemove = manualHistoricDict[key]
        manualHistory = manualHistory - valueToRemove![0]
        manualHistoricDict.removeValue(forKey: key)
        UserDefaults.standard.set(manualHistory, forKey: "ManualHistoricData")
        UserDefaults.standard.set(manualHistoricDict, forKey: "manualHistoricDict")
    }
}

public func addManualHistoryRecord(key: String, value: Double) {
    var manualHistory = UserDefaults.standard.double(forKey: "ManualHistoricData")
    var manualHistoricDict = UserDefaults.standard.dictionary(forKey: "manualHistoricDict")
    if manualHistoricDict == nil {
        manualHistoricDict = [:]
    }
    manualHistory = manualHistory + value
    manualHistoricDict![key] = value
    UserDefaults.standard.set(manualHistory, forKey: "ManualHistoricData")
    UserDefaults.standard.set(manualHistoricDict, forKey: "manualHistoricDict")
}

public func removeManualRecord(key: String) {
    if var manualData = UserDefaults.standard.dictionary(forKey: "ManualData") as? [String: [Double]] {
        manualData.removeValue(forKey: key)
        UserDefaults.standard.set(manualData, forKey: "ManualData")
    }
}

public func addManualRecord(key: String, value: [Double]) {
    if var manualData = UserDefaults.standard.dictionary(forKey: "ManualData") as? [String: [Double]] {
        manualData[key] = value
        UserDefaults.standard.set(manualData, forKey: "ManualData")
    } else {
        let newManualData: [String: [Double]] = [key: value]
        UserDefaults.standard.set(newManualData, forKey: "ManualData")
    }
}