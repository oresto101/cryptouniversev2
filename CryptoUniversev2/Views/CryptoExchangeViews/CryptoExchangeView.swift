// import SwiftUI
//
// struct CryptoExchangeView: View {
//    var cryptoInfo: [CryptoInfo]
//    var cryptoExchange: String
//
//    var body: some View {
//        LazyVStack(spacing: 10.0) {
//            ForEach(cryptoInfo, id: \.self) { cryptoInfo in
//                CryptoInfoView(cryptoInfo: cryptoInfo, cryptoExchange: cryptoExchange)
//            }
//        }
//    }
// }

// struct CryptoExchangeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CryptoExchangeView(infobox: InfoBox(name: "All", totalBalance: 1000, dailyProfitLoss: 100,netProfitLoss: 100, dailyProfitLossPercentage: 100, netProfitLossPercentage: 100),
//                           cryptoInfo: [CryptoInfo(name: "Ethereum", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100),
//                                        CryptoInfo(name: "Binance Coin", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100)])
//    }
// }
