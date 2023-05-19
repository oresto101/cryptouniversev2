import Foundation

public func removeManualHistoryRecord(key: String) {
    print("Call remove manual hist")
    var manualHistory = UserDefaults.standard.double(forKey: "ManualHistoricData")
    print(manualHistory)
    if var manualHistoricDict = UserDefaults.standard.dictionary(forKey: "manualHistoricDict") as? [String: Double] {
        let valueToRemove = manualHistoricDict[key]
        manualHistory = manualHistory - valueToRemove!
        manualHistoricDict.removeValue(forKey: key)
        if manualHistory == 0 {
            UserDefaults.standard.set(nil, forKey: "ManualHistoricData")
        } else {
            UserDefaults.standard.set(manualHistory, forKey: "ManualHistoricData")
        }
        if manualHistoricDict.count == 0 {
            UserDefaults.standard.set(nil, forKey: "manualHistoricDict")
        } else {
            UserDefaults.standard.set(manualHistoricDict, forKey: "manualHistoricDict")
        }
        print("Manual history removed")
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
    print("Call remove manual rec")
    if var manualData = UserDefaults.standard.dictionary(forKey: "ManualData") as? [String: Double] {
        manualData.removeValue(forKey: key)
        if manualData.count == 0 {
            UserDefaults.standard.set(nil, forKey: "ManualData")
        } else {
            UserDefaults.standard.set(manualData, forKey: "ManualData")
        }
        print("Manual record removed")
    }
}

public func addManualRecord(key: String, value: Double) {
    if var manualData = UserDefaults.standard.dictionary(forKey: "ManualData") as? [String: Double] {
        manualData[key] = value
        UserDefaults.standard.set(manualData, forKey: "ManualData")
    } else {
        let newManualData: [String: Double] = [key: value]
        UserDefaults.standard.set(newManualData, forKey: "ManualData")
    }
}
