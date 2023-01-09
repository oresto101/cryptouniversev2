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
                                ScrollView(showsIndicators: false) {
                                    RoundedRectangle(cornerRadius: 14)
                                        .padding()
                                        .frame(width: 350.0, height: 250.0)
                                        .foregroundColor(Color("MainColor"))
                                        .overlay(
                                            VStack(){
                                                HStack{
                                                    Text(infobox.name)
                                                        .font(.headline)
                                                        .fontWeight(.bold)
                                                    if (infobox.name != "Overall"){
                                                        Menu{
                                                            Button(action:{ removeCryptoExchange(id: getExchangeByName(name: infobox.name).id)
                                                            }) {
                                                                Label("Delete", systemImage: "minus.circle")
                                                            }
                                                        }label: {
                                                            Image("RemoveExchange")
                                                        }
                                                    }
                                                }
                                                HStack(){
                                                    VStack(alignment: .leading){
                                                        Text("Total balance")
                                                        Text("Daily P/L")
                                                        Text("Total P/L")
                                                    }
                                                    .offset(x: -30.0)
                                                    VStack(alignment: .trailing){
                                                        Text(String(roundDoubles(val: infobox.totalBalance)))
                                                        Text(formatBalancePLAndPercentageToString(balance: infobox.dailyProfitLoss,
                                                                                                  percentage: infobox.dailyProfitLossPercentage))
                                                        Text(formatBalancePLAndPercentageToString(balance: infobox.netProfitLoss,
                                                                                                  percentage: infobox.netProfitLossPercentage))
                                                    }
                                                    .offset(x: 30.0)
                                                }
                                            }
                                        )
                                    CryptoExchangeView(cryptoInfo: getCryptoInfoForExchange(exchange: infobox.name))
                                }
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
    
    func removeCryptoExchange(id: String) {
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

        let _: Void = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                self.cryptoInfo = nil
                self.infoBoxes = nil
                updateData()
            }
        }.resume()
    }
    
    private func loadData() {
        if (infoBoxes == nil || cryptoInfo == nil) {
            print("Loading")
            self.loadInfoBoxes()
            self.loadCryptoInfo()
        }
    }
    
    private func updateData() {
        print("Updating")
        self.loadInfoBoxes()
        self.loadCryptoInfo()
    }
    
    private func getCryptoInfoForExchange(exchange: String) -> [CryptoInfo] {
        return self.cryptoInfo![exchange]!
    }
}
