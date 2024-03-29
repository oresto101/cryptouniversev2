import SwiftUI

struct CryptoInfoView: View {
    var cryptoInfo: CryptoInfo
    var cryptoExchange: String
    @State private var disabled = false

    var body: some View {
        if !disabled {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 320.0, height: 75.0)
                .foregroundColor(calculateColorForBox(profitLoss: cryptoInfo.dailyProfitLoss))
                .overlay(
                    VStack {
                        HStack {
                            if UIImage(named: cryptoInfo.name.lowercased()) == nil {
                                Image("default")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(cryptoInfo.name.lowercased())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                            }

                            Text(cryptoInfo.name)
                                .font(.headline)
                                .fontWeight(.bold)
                            if cryptoExchange == "Manual" {
                                Menu {
                                    Button(action: { removeCryptocurrency(name: cryptoInfo.name)
                                    }) {
                                        Label("Delete", systemImage: "minus.circle")
                                    }
                                } label: {
                                    Image("RemoveExchange")
                                }
                            }
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total price: ")
                                Text("Amount:  ")
                            }
                            .position(x: 70, y: 10)
                            VStack(alignment: .trailing) {
                                if cryptoInfo.price != 0.0 {
                                    Text(formatBalancePLAndPercentageToString(
                                        balance: cryptoInfo.balance,
                                        percentage: cryptoInfo.dailyProfitLoss
                                    ))
                                } else {
                                    Text("N/A (N/A)")
                                }
                                Text(String(cryptoInfo.amount))
                            }
                            .offset(x: -15, y: -10)
//                            .position(x: 80, y: 10)
                        }
                        .font(.subheadline)
                    }
                )
        }
    }

    func calculateColorForBox(profitLoss: Double) -> Color {
        if profitLoss >= 0 {
            return Color("ProfitColor")
        } else {
            return Color("LossColor")
        }
    }

    private func removeCryptocurrency(name: String) {
        removeManualHistoryRecord(key: name)
        removeManualRecord(key: name)
    }
}

struct CryptoInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoInfoView(
            cryptoInfo: CryptoInfo(
                name: "ETH",
                balance: 0.0,
                amount: 0.0,
                price: 0.0,
                dailyProfitLoss: 0.0
            ),
            cryptoExchange: ""
        )
    }
}
