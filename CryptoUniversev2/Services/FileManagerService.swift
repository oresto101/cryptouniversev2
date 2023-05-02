import Foundation

public func getJSONFilePath() -> URL? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    return documentsDirectory.appendingPathComponent("coinList.json")
}

public func saveJSONDataToFile(_ data: Data) {
    guard let fileURL = getJSONFilePath() else { return }

    do {
        try data.write(to: fileURL, options: .atomic)
        print("JSON data saved successfully")
    } catch {
        print("Error saving JSON data: \(error.localizedDescription)")
    }
}

public func readJSONDataFromFile(completion: @escaping (Data?, Error?) -> Void) {
    guard let fileURL = getJSONFilePath() else {
        completion(nil, nil)
        return
    }

    do {
        let data = try Data(contentsOf: fileURL)
        completion(data, nil)
    } catch {
        completion(nil, error)
    }
}

public func loadCoinList(completion: @escaping (Data?, Error?) -> Void) {
    readJSONDataFromFile { data, _ in
        if let data {
            print("Loaded JSON data from file")
            completion(data, nil)
        } else {
            print("Fetching JSON data from API")
            fetchCoinList(completion: completion)
        }
    }
}
