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
        ExchangeForList(id: "5", name: "Kraken", logo: "kraken_logo"),
    ]

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                DisclosureGroup {
                    Text(
                        "Go to the 'Add Cryptoexchange' page and select exchange you would like to add. If you have troubles obtaining API keys - you may click on an question button to open a video tutorial."
                    )
                    .foregroundColor(.white)
                    .padding()
                } label: {
                    Text("How do I add a new exchange to the app?")
                }
                DisclosureGroup("How secure is this application?") {
                    Text(
                        "Our app is designed with security as a top priority. Your API keys are stored locally on your device and all requests to exchanges are made directly from your device. We do not have access to your keys or data."
                    )
                    .foregroundColor(.white)
                    .padding()
                }
                DisclosureGroup("Can I track multiple exchanges") {
                    Text(
                        "Yes, you can add and track as many exchanges as you'd like. Just repeat the process of adding a new exchange for each one you want to track. However, remember that you can track only one account for each exchange"
                    )
                    .foregroundColor(.white)
                    .padding()
                }
                DisclosureGroup("Troubles connecting an exchange") {
                    Text(
                        "First, double-check that you've entered the API key correctly. If the problem persists, there might be a connectivity issue or a problem with the exchange's API. Try again later, and if it still doesn't work, please contact us for assistance."
                    )
                    .foregroundColor(.white)
                    .padding()
                }
                DisclosureGroup("How often is the data updated?") {
                    Text(
                        "The data from each exchange is updated in real-time. Please note that there might be a slight delay due to connectivity and response time from the exchanges' APIs."
                    )
                    .foregroundColor(.white)
                    .padding()
                }
                DisclosureGroup("How do I remove an exchange?") {
                    Text(
                        "You can remove an exchange by navigating to this exchange in the home page, and then by clicking 3 dots buttons near the name of the exchange."
                    )
                    .foregroundColor(.white)
                    .padding()
                }
                DisclosureGroup("Can I use the app without an Internet?") {
                    Text(
                        "Internet conection is strongly reqired to use CryptoUniverse App."
                    )
                    .foregroundColor(.white)
                    .padding()
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
