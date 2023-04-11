import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

import SwiftUI

struct AddCryptoExchangeView: View {
    @State private var selectedExchange: Exchange = .binance
    @State private var exchangeAPI: String = ""
    @State private var exchangeSecret: String = ""
    @State private var exchangePassphrase: String = ""
    @State private var loading = false
    @State private var loaded = false
    @State private var loadedWithError = false

    var body: some View {
        if loaded {
            MainView().navigationBarBackButtonHidden(true)
        } else {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                List {
                    Section {
                        Picker("Exchange", selection: $selectedExchange) {
                            ForEach(Exchange.allCases, id: \.self) { exchange in Text(exchange.name).tag(exchange)
                            }
                        }
                        .accessibility(identifier: "picker")
                        TextField(
                            "Exchange API",
                            text: $exchangeAPI
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        TextField(
                            "Exchange Secret",
                            text: $exchangeSecret
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        if selectedExchange.requiresPassphrase {
                            TextField(
                                "Exchange Passphrase",
                                text: $exchangePassphrase
                            )
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        }
//                        .isHidden(!selectedExchange.requiresPassphrase, remove: !selectedExchange.requiresPassphrase)
                    }
                    Button("Add cryptoexchange") {
                        addCryptoExchange(
                            exchangeID: selectedExchange.id,
                            exchangeAPI: exchangeAPI,
                            exchangeSecret: exchangeSecret,
                            exchangePassphrase: exchangePassphrase
                        )
                    }

                    .disabled(
                        exchangeAPI.isEmpty || exchangeSecret
                            .isEmpty || (exchangePassphrase.isEmpty && selectedExchange.requiresPassphrase) ||
                            (!exchangePassphrase.isEmpty && !selectedExchange.requiresPassphrase))
                }
                .scrollContentBackground(.hidden)
            }
            .alert("Fake credentials", isPresented: self.$loadedWithError) {
                Button("Dismiss") {}
            }
        }
    }
    

    func addCryptoExchange(
        exchangeID: String,
        exchangeAPI: String,
        exchangeSecret: String,
        exchangePassphrase: String
    ) {
        let
            parameters = [
                [
                    "key": "exchange",
                    "value": exchangeID,
                    "type": "text",
                ],
                [
                    "key": "exchangeAPI",
                    "value": exchangeAPI,
                    "type": "text",
                ],
                [
                    "key": "exchangeSecret",
                    "value": exchangeSecret,
                    "type": "text",
                ],
                [
                    "key": "exchangePassphrase",
                    "value": exchangePassphrase,
                    "type": "text",
                ],
            ] as [[String: Any]]

        print(parameters)
    }
}

struct AddCryptoExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoExchangeView()
    }
}
