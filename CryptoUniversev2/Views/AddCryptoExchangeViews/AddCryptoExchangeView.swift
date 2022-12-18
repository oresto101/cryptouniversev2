//
//  AddCryptoExchangeView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 18/12/2022.
//

import SwiftUI

var requirePassphrase = [Exchange.binance, Exchange.okx]
enum Exchange: String, CaseIterable, Identifiable, Equatable {
    case binance, okx, whitebit
    var id: String { return self.rawValue }

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
        List {
            Picker("Exchange", selection: $selectedExchange) {
                Text("Binance").tag(Exchange.binance)
                Text("OKX").tag(Exchange.okx)
                Text("WhiteBit").tag(Exchange.whitebit)
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
            Button ("Add cryptoexchange"){
                addCryptoExchangeService.addCryptoExchange(exchangeID: selectedExchange.id, exchangeAPI: exchangeAPI, exchangeSecret: exchangeSecret, exchangePassphrase: exchangeSecret)
            }
            
        }
    }
}

struct AddCryptoExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoExchangeView()
    }
}
