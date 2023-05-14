import Foundation
// import NetworkService
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

import SwiftUI

struct AddCryptoExchangeView: View {
//    @State private var selectedExchange: Exchange = .binance
    @State public var selectedExchange: Exchange
    @State private var exchangeAPI: String = ""
    @State private var exchangeSecret: String = ""
    @State private var exchangePassphrase: String = ""
    @State private var loaded = false
    @State private var loadedWithError = false

    var body: some View {
        if loaded {
            HomeView().navigationBarBackButtonHidden(true)
        } else {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack {
                    Text(selectedExchange.name)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                    Form {
                        Section {
                            //                        Picker("Exchange", selection: $selectedExchange) {
                            //
                            //                        }
                            //                        .accessibility(identifier: "picker")
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
                                (!exchangePassphrase.isEmpty && !selectedExchange.requiresPassphrase)
                        )
                    }
                    .scrollContentBackground(.hidden)
                }
                .alert("Fake credentials", isPresented: $loadedWithError) {
                    Button("Dismiss") {}
                }
            }
        }
    }

    func addCryptoExchange(exchangeID: String,
                           exchangeAPI: String,
                           exchangeSecret: String,
                           exchangePassphrase: String)
    {
        switch exchangeID {
        case "1":
            parseBinance(apiKey: exchangeAPI, secretKey: exchangeSecret, newData: true) { isValid in
                if isValid {
                    print("The exchange is valid.")
                    loaded = true
                } else {
                    loadedWithError = true
                }
            }
        case "2":
            parseOKX(apiKey: exchangeAPI, secretKey: exchangeSecret, passphrase: exchangePassphrase, newData: true) { isValid in
                if isValid {
                    print("The exchange is valid.")
                    loaded = true
                } else {
                    loadedWithError = true
                }
            }
        case "3":
            parseWhiteBit(apiKey: exchangeAPI, secretKey: exchangeSecret, newData: true) { isValid in
                if isValid {
                    print("The exchange is valid.")
                    loaded = true
                } else {
                    loadedWithError = true
                }
            }
        case "4":
            parseGemini(apiKey: exchangeAPI, secretKey: exchangeSecret, newData: true) { isValid in
                if isValid {
                    print("The exchange is valid.")
                    loaded = true
                } else {
                    loadedWithError = true
                }
            }
        case "5":
            parseKraken(apiKey: exchangeAPI, secretKey: exchangeSecret, newData: true) { isValid in
                if isValid {
                    print("The exchange is valid.")
                    loaded = true
                } else {
                    loadedWithError = true
                }
            }
        default:
            loadedWithError = true
        }
    }
}

struct AddCryptoExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoExchangeView(selectedExchange: getExchangeByName(name: "Binance"))
    }
}
