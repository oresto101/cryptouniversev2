import SwiftUI

let exchangeDispatchGroup = DispatchGroup()
let coinMarketCapDispatchGroup = DispatchGroup()

struct HomeView: View {
    @StateObject var networkMonitor = NetworkMonitor()
    @State private var infoBoxes: [InfoBox] = []
    @State private var cryptoInfo: [String: [CryptoInfo]] = [:]
    @State private var loadingBoxes = false
    @State private var loadingInfo = false
    @State private var noData = false

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            mainTabView
        }
    }

    var mainTabView: some View {
        TabView {
            if !infoBoxes.isEmpty, !cryptoInfo.isEmpty {
                contentForEachInfoBox
                    .refreshable {
                        updateData()
                    }
            } else {
                if noData {
                    noDataView
                } else {
                    loadingProgressView
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear(perform: loadData)
    }

    var contentForEachInfoBox: some View {
        ForEach(infoBoxes, id: \.self) { infobox in
            infoBoxContent(infobox: infobox)
        }
    }

    func infoBoxContent(infobox: InfoBox) -> some View {
        ScrollView {
            VStack {
                if loadingBoxes || loadingInfo {
                    loading_view
                }
                infoBoxOverlay(infobox: infobox)
            }
        }
    }

    func infoBoxOverlay(infobox: InfoBox) -> some View {
        ScrollView(showsIndicators: false) {
            RoundedRectangle(cornerRadius: 14)
                .padding()
                .frame(width: 350.0, height: 250.0)
                .foregroundColor(Color("MainColor"))
                .overlay(
                    VStack {
                        infoBoxHeader(infobox: infobox)
                        CryptoBoxView(infobox: infobox)
                    }
                )
            if !loadingBoxes, !loadingInfo {
                cryptoExchangeView(
                    cryptoInfo: cryptoInfo[infobox.name]!,
                    cryptoExchange: infobox.name
                )
            }
        }
    }

    func infoBoxHeader(infobox: InfoBox) -> some View {
        HStack {
            Text(infobox.name)
                .font(.headline)
                .fontWeight(.bold)
            if infobox.name != "Overall", infobox.name != "Manual" {
                Menu {
                    Button(action: {
                        removeCryptoExchange(infobox: infobox)
                    }) {
                        Label("Delete", systemImage: "minus.circle")
                    }
                } label: {
                    Image("RemoveExchange")
                }
            }
        }
    }

    func cryptoExchangeView(cryptoInfo: [CryptoInfo], cryptoExchange: String) -> some View {
        AnyView(
            LazyVStack(spacing: 10.0) {
                ForEach(cryptoInfo, id: \.self) { cryptoInfo in
                    cryptoInfoView(cryptoInfoBox: cryptoInfo, cryptoExchange: cryptoExchange)
                }
            }
        )
    }

    func cryptoInfoView(cryptoInfoBox: CryptoInfo, cryptoExchange: String) -> some View {
        func calculateColorForBox(profitLoss: Double) -> Color {
            if profitLoss >= 0 {
                return Color("ProfitColor")
            } else {
                return Color("LossColor")
            }
        }

        func removeCryptocurrency(name: String) {
            removeManualHistoryRecord(key: name)
            removeManualRecord(key: name)
            (infoBoxes, cryptoInfo, noData) = retrieveDataAndParseCryptoInfo()
        }

        return Group {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 320.0, height: 75.0)
                .foregroundColor(calculateColorForBox(profitLoss: cryptoInfoBox.dailyProfitLoss))
                .overlay(
                    VStack {
                        HStack {
                            if UIImage(named: cryptoInfoBox.name.lowercased()) == nil {
                                Image("default")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(cryptoInfoBox.name.lowercased())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                            }

                            Text(cryptoInfoBox.name)
                                .font(.headline)
                                .fontWeight(.bold)
                            if cryptoExchange == "Manual" {
                                Menu {
                                    Button(action: { removeCryptocurrency(name: cryptoInfoBox.name)
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
                                Text(formatBalancePLAndPercentageToString(
                                    balance: cryptoInfoBox.balance,
                                    percentage: cryptoInfoBox.dailyProfitLoss
                                ))
                                Text(String(cryptoInfoBox.amount))
                            }
                            .offset(x: -15, y: -10)
                        }
                        .font(.subheadline)
                    }
                )
        }
    }

    var loadingProgressView: some View {
        let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

        return ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(2)
            .onReceive(timer) { _ in
                loadData()
            }
    }

    var noDataView: some View {
        VStack {
            Text("Add a Crypto Exchange to see your data")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: 300, height: 200)
        .background(Color.gray)
        .cornerRadius(10)
        .padding()
    }

    var loading_view: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1))
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }.frame(width: 30, height: 30, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
    }

    func removeCryptoExchange(infobox: InfoBox) {
        UserDefaults.standard.removeObject(forKey: "\(infobox.name)API")
        UserDefaults.standard.removeObject(forKey: "\(infobox.name)Secret")
        UserDefaults.standard.removeObject(forKey: "\(infobox.name)Data")
        UserDefaults.standard.removeObject(forKey: "\(infobox.name)HistoricData")
        (infoBoxes, cryptoInfo, noData) = retrieveDataAndParseCryptoInfo()
    }

    private func loadData() {
        if !areAnyCredentialsStored() {
            noData = true
        } else {
            updateData()
        }
    }

    private func areAnyCredentialsStored() -> Bool {
        var atLeastOneStored = false
        exchanges.forEach {
            exchangeName in
            if let _ = (UserDefaults.standard.dictionary(forKey: "\(exchangeName)Data")) {
                atLeastOneStored = true
            }
        }
        return atLeastOneStored
    }

    private func updateData() {
        parseCredentials()
        exchangeDispatchGroup.notify(queue: .global()) {
            storeChangesForCryptoInUsd()
            coinMarketCapDispatchGroup.notify(queue: .main) {
                (infoBoxes, cryptoInfo, noData) = retrieveDataAndParseCryptoInfo()
                print(infoBoxes)
            }
        }
    }
}
