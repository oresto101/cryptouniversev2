import SwiftUI

struct ExchangeForList {
    var id: String
    var name: String
    var logo: String
}

struct ExchangeCard: View {
    var exchange: ExchangeForList

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exchange.name)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            Spacer()
            Image(exchange.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
        }
        .padding()
        .background(Color("MainColor"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ExchangeListView: View {
    var exchanges: [ExchangeForList] = [
        ExchangeForList(id: "1", name: "Binance", logo: "binance_logo"),
        ExchangeForList(id: "2", name: "OKX", logo: "okx_logo"),
//        ExchangeForList(id: "3", name: "WhiteBit", logo: "wb_logo"),
        ExchangeForList(id: "4", name: "Gemini", logo: "gemini_logo"),
        ExchangeForList(id: "5", name: "Kraken", logo: "kraken_logo"),
    ]

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                ForEach(exchanges, id: \.id) { exchange in
                    NavigationLink(destination: AddCryptoExchangeView(selectedExchange: getExchangeByName(name: exchange.name))) {
                        ExchangeCard(exchange: exchange)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}
