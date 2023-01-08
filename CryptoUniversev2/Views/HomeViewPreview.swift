//
//  HomeView.swift
//  CryptoUniversev2
//
//  Created by Kirill Kostakov on 05.01.2023.
//

import SwiftUI

struct HomeViewPreview: View {
//    @State private var infoBoxes: [InfoBox]?
//    @State private var cryptoInfo: [String: [CryptoInfo]]?
    var infoBoxes = [InfoBox(name: "All", totalBalance: 1000, dailyProfitLoss: 100,netProfitLoss: 100, dailyProfitLossPercentage: 100, netProfitLossPercentage: 100), InfoBox(name: "Binance", totalBalance: 1000, dailyProfitLoss: 100, netProfitLoss: 100, dailyProfitLossPercentage: 100, netProfitLossPercentage: 100), InfoBox(name: "OKX", totalBalance: 1000, dailyProfitLoss: 100, netProfitLoss: 100, dailyProfitLossPercentage: 100, netProfitLossPercentage: 100)]
    var cryptoInfo=["All": [CryptoInfo(name: "Ethereum", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: 100),
                                                    CryptoInfo(name: "Binance Coin", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100)],
                                            "OKX": [CryptoInfo(name: "Ethereum", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100),
                                                            CryptoInfo(name: "Binance Coin", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100)],
                                            "Binance": [CryptoInfo(name: "Ethereum", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100),
                                                            CryptoInfo(name: "Binance Coin", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100)]]
    @ObservedObject var loginService = LoginService.shared
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            TabView(){
                
                if (infoBoxes != nil && cryptoInfo != nil) {
                    ForEach(infoBoxes, id: \.self) {infobox in
                        ScrollView{
                            VStack{
                                CryptoExchangeView(infobox: infobox, cryptoInfo: getCryptoInfoForExchange(exchange: infobox.name))
                            }
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
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
    
    
    private func getCryptoInfoForExchange(exchange: String) -> [CryptoInfo] {
        return self.cryptoInfo[exchange]!
    }
}


struct HomeViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewPreview()
    }
}
