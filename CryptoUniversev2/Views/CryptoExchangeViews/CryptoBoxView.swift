import SwiftUI

struct CryptoBoxView: View {
    var infobox: InfoBox

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Total balance")
                Text("Daily P/L")
                Text("Total P/L")
            }
            .offset(x: -5.0)
            VStack(alignment: .trailing) {
                Text(String(roundDoubles(val: infobox.totalBalance)))
                Text(formatBalancePLAndPercentageToString(
                    balance: infobox.dailyProfitLoss,
                    percentage: infobox.dailyProfitLossPercentage
                ))
                Text(formatBalancePLAndPercentageToString(
                    balance: infobox.netProfitLoss,
                    percentage: infobox.netProfitLossPercentage
                ))
            }
            .offset(x: 5.0)
        }
    }
}

struct CryptoBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoBoxView(
            infobox: InfoBox(name: "Binance", totalBalance: 123_123_123, dailyProfitLoss: 12313, netProfitLoss: 123_123_123, dailyProfitLossPercentage: 123_312, netProfitLossPercentage: 12313)
        )
    }
}
