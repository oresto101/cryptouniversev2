import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

import SwiftUI

struct AddCryptoCurrencyView: View {
    @State private var cryptoCode: String = ""
    @State private var quantity: String = "0"
    @State private var loaded = false
    @State private var loadedWithError = false

    var body: some View {
        if loaded {
            HHView().navigationBarBackButtonHidden(true)
        } else {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                Form {
                    Section {
                        TextField(
                            "Cryptocurrency Code",
                            text: $cryptoCode
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        TextField(
                            "Quantity",
                            text: $quantity
                        )
                        .keyboardType(.decimalPad)
                    }
                    Button("Add Cryptocurrency") {
                        addCryptocurrency(cryptoCode: cryptoCode, quantity: quantity)
                    }

                    .disabled(quantity.isEmpty || cryptoCode.isEmpty || Double(quantity) == 0)
                }
                .scrollContentBackground(.hidden)
            }
            .alert("Cryptocurrency doesn't exist", isPresented: $loadedWithError) {
                Button("Dismiss") {}
            }
        }
    }

    func addCryptocurrency(cryptoCode: String, quantity: String) {
        convertCoinToUSD(name: cryptoCode, amount: Double(quantity)!) {
            coinData in
            if coinData != -1.0 {
                addManualHistoryRecord(key: cryptoCode.uppercased(), value: coinData)
                addManualRecord(key: cryptoCode.uppercased(), value: Double(quantity) ?? 0.0)
                loaded = true
            }
            loadedWithError = true
        }
    }
}

struct AddCryptoCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoCurrencyView()
    }
}
