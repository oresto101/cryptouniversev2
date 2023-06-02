//
//  HelpListView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 02/06/2023.
//

import SwiftUI


struct HelpListView: View {
    var exchanges: [ExchangeForList] = [
        ExchangeForList(id: "1", name: "Binance", logo: "binance_logo"),
        ExchangeForList(id: "2", name: "OKX", logo: "okx_logo"),
        ExchangeForList(id: "4", name: "Gemini", logo: "gemini_logo"),
        ExchangeForList(id: "5", name: "Kraken", logo: "kraken_logo")
    ]
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                DisclosureGroup {
                    VStack {
                        ForEach(exchanges, id: \.id) { exchange in
                            NavigationLink(destination: AddCryptoExchangeView(selectedExchange: getExchangeByName(name: exchange.name))) {
                                ExchangeCard(exchange: exchange)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                } label: {
                    Text("How do I add an exchange?")

                }
                Spacer()
            }
            .padding()
        }
    }
}

struct HelpListView_Previews: PreviewProvider {
    static var previews: some View {
        HelpListView()
    }
}
