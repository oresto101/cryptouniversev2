//
//  AddCryptoExchangeView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 18/12/2022.
//

import SwiftUI

var requirePassphrase = [Exchange.okx]
var exchangeToIdDict: [Exchange: Int] = [Exchange.binance: 1, Exchange.okx: 2, Exchange.whitebit: 10, Exchange.manual: 6, Exchange.kraken: 8, Exchange.gemini: 9]
enum Exchange: String, CaseIterable, Identifiable, Equatable {
    case binance, okx, whitebit, manual, kraken, gemini
    
    var id: Int { return exchangeToIdDict[self]! }
    var requiresPassphrase: Bool {
        return requirePassphrase.contains(self)
    }
}

struct AddCryptoExchangeView: View {
    
    
    
    @ObservedObject var addCryptoExchangeService = AddCryptoExchangeService.shared
    @State private var selectedExchange: Exchange = .binance
    @State private var exchangeAPI: String = ""
    @State private var exchangeSecret: String = ""
    @State private var exchangePassphrase: String = ""

    var body: some View {
        VStack (){
            
            List {
                Section{
                    Picker("Exchange", selection: $selectedExchange) {
                        Text("Binance").tag(Exchange.binance)
                        Text("OKX").tag(Exchange.okx)
                        Text("WhiteBit").tag(Exchange.whitebit)
                        Text("Manual").tag(Exchange.manual)
                        Text("Kraken").tag(Exchange.kraken)
                        Text("Gemini").tag(Exchange.gemini)
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
                    addCryptoExchangeService.addCryptoExchange(exchangeID: selectedExchange.id, exchangeAPI: exchangeAPI, exchangeSecret: exchangeSecret, exchangePassphrase: exchangeSecret)
                }

                .disabled(exchangeAPI.isEmpty || exchangeSecret.isEmpty || (exchangePassphrase.isEmpty && selectedExchange.requiresPassphrase) ||
                          (!exchangePassphrase.isEmpty && !selectedExchange.requiresPassphrase))
            }
            
            
            
        }
    }
}

struct AddCryptoExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoExchangeView()
    }
}
