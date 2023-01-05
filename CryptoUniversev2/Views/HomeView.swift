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
        TabView(){
            if (infoBoxes != nil && cryptoInfo != nil) {
                ScrollView{
                    VStack{
                        ForEach(infoBoxes!, id: \.self) {infobox in
                            CryptoExchangeView(infobox: infobox, cryptoInfo: getCryptoInfoForExchange(exchange: infobox.name))
                        }
                    }
                }
                .refreshable {
                    loadData()
                }
            }
        }
            .tabViewStyle(PageTabViewStyle())
            .onAppear(perform: loadData)
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
    
    private func loadData() {
        if (infoBoxes == nil || cryptoInfo == nil) {
            self.loadInfoBoxes()
            sleep(2)
            self.loadCryptoInfo()
        }
    }
    
    private func getCryptoInfoForExchange(exchange: String) -> [CryptoInfo] {
        return self.cryptoInfo![exchange]!
    }
}
