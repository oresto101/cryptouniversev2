import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

import SwiftUI

struct AddCryptoCurrencyView: View {
    @State private var cryptoCode: String = ""
    @State private var quantity: String = "0"
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
                        TextField(
                            "Cryptocurrency code",
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
                    Button("Add cryptocurrency") {
                        addCryptocurrency(cryptoCode: cryptoCode, quantity: quantity)
                    }

                    .disabled(quantity.isEmpty || cryptoCode.isEmpty)
                }
                .scrollContentBackground(.hidden)
            }
            .alert("Cryptocurrency doesn't exist", isPresented: self.$loadedWithError) {
                Button("Dismiss") {}
            }
        }
    }

    func addCryptocurrency(cryptoCode: String, quantity: String) { let
        parameters = [
            [
                "key": "coin",
                "value": cryptoCode,
                "type": "text",
            ],
            [
                "key": "quantity",
                "value": quantity,
                "type": "text",
            ],
        ] as [[String: Any]]

        print(parameters)
    }
}

struct AddCryptoCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoCurrencyView()
    }
}
