//
//  HomeView.swift
//  CryptoUniversev2
//
//  Created by Kirill Kostakov on 05.01.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var infoBoxes: [InfoBox]?
    @State private var cryptoInfo: [String: [CryptoInfo]]?
    @ObservedObject var loginService = LoginService.shared
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            TabView(){
                if (infoBoxes != nil && cryptoInfo != nil) {
                    ForEach(infoBoxes!, id: \.self) {infobox in
                        ScrollView{
                            VStack{
                                CryptoExchangeView(infobox: infobox, cryptoInfo: getCryptoInfoForExchange(exchange: infobox.name))
                            }
                        }
                    }
                    .refreshable {
                        updateData()
                    }
                }else{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear(perform: loadData)
        }
    }
    
    private func parseInfoBox(json: Data) -> [InfoBox] {
          let decoder = JSONDecoder()
          do {
            let box = try decoder.decode([InfoBox].self, from: json)
            return box
          } catch {
            return []
          }
        }
    
    func parseCryptoInfo(json: Data) -> [String: [CryptoInfo]] {
          let decoder = JSONDecoder()
          do {
            let info = try decoder.decode([String: [CryptoInfo]].self, from: json)
            return info
          } catch {
              return [:]
          }
        }
    
    private func loadInfoBoxes(){
        let parameters = "action=infoBoxes"
        let postData =  parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/request_data/")!,timeoutInterval: Double.infinity)
        request.addValue(loginService.token, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let _: Void = URLSession.shared
            .dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                let boxes = self.parseInfoBox(json: data!)
                self.infoBoxes = boxes
            }
        }.resume()
    }
    
    private func loadCryptoInfo(){
        let parameters = "action=cryptoInfo"
        let postData =  parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/request_data/")!,timeoutInterval: Double.infinity)
        request.addValue(loginService.token, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let _: Void = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                let cryptoBoxes = self.parseCryptoInfo(json: data!)
                self.cryptoInfo = cryptoBoxes
            }
        }.resume()
    }
    
    private func removeCryptoExchange(id: String) {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
        ] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var _: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/credentials/" + id + "/")!,timeoutInterval: Double.infinity)
        request.addValue(loginService.token, forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "DELETE"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    private func loadData() {
        if (infoBoxes == nil || cryptoInfo == nil) {
            self.loadInfoBoxes()
            self.loadCryptoInfo()
        }
    }
    
    private func updateData() {
        self.loadInfoBoxes()
        self.loadCryptoInfo()
    }
    
    private func getCryptoInfoForExchange(exchange: String) -> [CryptoInfo] {
        return self.cryptoInfo![exchange]!
    }
}
