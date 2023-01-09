//
//  AddCryptoExchangeView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 18/12/2022.
//

import SwiftUI



struct AddCryptoExchangeView: View {
    
    @ObservedObject var cryptoExchangeManagementService = CryptoExchangeManagementService.shared
    @State private var selectedExchange: Exchange = .binance
    @State private var exchangeAPI: String = ""
    @State private var exchangeSecret: String = ""
    @State private var exchangePassphrase: String = ""

    var body: some View {
            VStack (){
                List {
                    Section{
                        Picker("Exchange", selection: $selectedExchange) {
                            ForEach(Exchange.allCases, id: \.self) {exchange in Text(exchange.name).tag(exchange)
                            }
                        }
                        TextField(
                            "Exchange API",
                            text: $exchangeAPI)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        TextField(
                            "Exchange Secret",
                            text: $exchangeSecret)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        TextField(
                            "Exchange Passphrase",
                            text: $exchangePassphrase)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .isHidden(!selectedExchange.requiresPassphrase, remove: !selectedExchange.requiresPassphrase)
                    }
                    Button ("Add cryptoexchange"){
                        cryptoExchangeManagementService.addCryptoExchange(exchangeID: selectedExchange.id, exchangeAPI: exchangeAPI, exchangeSecret: exchangeSecret, exchangePassphrase: exchangeSecret)
                    }
                    
                    .disabled(exchangeAPI.isEmpty || exchangeSecret.isEmpty || (exchangePassphrase.isEmpty && selectedExchange.requiresPassphrase) ||
                              (!exchangePassphrase.isEmpty && !selectedExchange.requiresPassphrase))
                }
            
        }
            .foregroundColor(Color("BackgroundColor"))
    }
}

struct AddCryptoExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoExchangeView()
    }
}
