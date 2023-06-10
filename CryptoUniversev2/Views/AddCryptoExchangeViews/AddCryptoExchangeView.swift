import Foundation
// import NetworkService
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import SafariServices
import SwiftUI

struct AddCryptoExchangeView: View {
    @State public var selectedExchange: Exchange
    @State private var showingVideo = false
    @State private var exchangeAPI: String = ""
    @State private var exchangeSecret: String = ""
    @State private var exchangePassphrase: String = ""
    @State private var loaded = false
    @State private var loadedWithError = false

    let videoURLs = [
        "Binance": URL(string: "https://youtu.be/_AJ-QYyqIR8"),
        "OKX": URL(string: "https://youtu.be/GkkM4aBwmFM"),
        "Gemini": URL(string: "https://youtu.be/e1zROVaQzoI"),
        "Kraken": URL(string: "https://youtu.be/BzqhWVTgwr8"),
    ]

    var body: some View {
        if loaded {
            HHView().navigationBarBackButtonHidden(true)
        } else {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                TabView {
                    VStack {
                        Text(selectedExchange.name)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                        Form {
                            Section {
                                SecureField(
                                    "Exchange API",
                                    text: $exchangeAPI
                                )
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                SecureField(
                                    "Exchange Secret",
                                    text: $exchangeSecret
                                )
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                if selectedExchange.requiresPassphrase {
                                    SecureField(
                                        "Exchange Passphrase",
                                        text: $exchangePassphrase
                                    )
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                }
                            }
                            Button("Add Cryptoexchange") {
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
                        Spacer()
                        Button(action: {
                            showingVideo = true
                        }) {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .sheet(isPresented: $showingVideo) {
                            SafariView(
                                url: videoURLs[selectedExchange.name] ?? URL(string: "https://youtube.com")!
                            )
                        }
                        Spacer()
                    }
                    .alert("Fake Credentials", isPresented: $loadedWithError) {
                        Button("Dismiss") {}
                    }
                }
                .tabViewStyle(PageTabViewStyle())
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
