import Foundation

public func removeManualHistoryRecord(key: String) {
//    UserDefaults.standard.set(0, forKey: "manualHistoricDict")
//    UserDefaults.standard.set(0, forKey: "ManualHistoricData")
    var manualHistory = UserDefaults.standard.double(forKey: "ManualHistoricData")
    if var manualHistoricDict = UserDefaults.standard.dictionary(forKey: "manualHistoricDict") as? [String: Double] {
        let valueToRemove = manualHistoricDict[key]
        print("Removing history")
        print(valueToRemove)
        print(manualHistory)
        manualHistory = manualHistory - valueToRemove!
        print(manualHistory)
        manualHistoricDict[key] = 0
        if manualHistory == 0 {
            UserDefaults.standard.set(nil, forKey: "ManualHistoricData")
        } else {
            print(manualHistory)
            UserDefaults.standard.set(manualHistory, forKey: "ManualHistoricData")
        }
        if manualHistoricDict.count == 0 {
            UserDefaults.standard.set(nil, forKey: "manualHistoricDict")
        } else {
            print(manualHistoricDict)
            UserDefaults.standard.set(manualHistoricDict, forKey: "manualHistoricDict")
        }
    }
}

public func addManualHistoryRecord(key: String, value: Double) {
    var manualHistory = UserDefaults.standard.double(forKey: "ManualHistoricData")
    var manualHistoricDict = UserDefaults.standard.dictionary(forKey: "manualHistoricDict") as? [String: Double]
    if manualHistoricDict == nil {
        manualHistoricDict = [:]
    }
    
    manualHistory = manualHistory + value
    
    if let currentValue = manualHistoricDict?[key] {
           let updatedValue = currentValue + value
           manualHistoricDict?[key] = updatedValue
       } else {
           manualHistoricDict?[key] = value
       }
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
            if let currentValue = manualData[key] {
                let updatedValue = currentValue + value
                manualData[key] = updatedValue
                UserDefaults.standard.set(manualData, forKey: "ManualData")
            } else {
                manualData[key] = value
                UserDefaults.standard.set(manualData, forKey: "ManualData")
            }
        } else {
            let manualData = [key: value]
            UserDefaults.standard.set(manualData, forKey: "ManualData")
        }
}
