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
            .offset(x: -30.0)
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
            .offset(x: 30.0)
        }
    }
}
