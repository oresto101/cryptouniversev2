import SwiftUI

let dispatchGroup = DispatchGroup()

struct HomeView: View {
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
                    cryptoInfo: getCryptoInfoForExchange(exchange: infobox.name),
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
                    cryptoInfoView(cryptoInfo: cryptoInfo, cryptoExchange: cryptoExchange)
                }
            }
        )
    }

    func cryptoInfoView(cryptoInfo: CryptoInfo, cryptoExchange: String) -> some View {
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
            parseCryptoInfo()
        }

        return Group {
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
                                Text(formatBalancePLAndPercentageToString(
                                    balance: cryptoInfo.balance,
                                    percentage: cryptoInfo.dailyProfitLoss
                                ))
                                Text(String(cryptoInfo.amount))
                            }
                            .offset(x: -15, y: -10)
                        }
                        .font(.subheadline)
                    }
                )
        }
    }

    var loadingProgressView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(2)
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
        parseCryptoInfo()
    }

    private func loadData() {
        print("Loading")
        if !areAnyCredentialsStored() {
            noData = true
        }
        else {
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
        print("Updating")
        parseCredentials()
        dispatchGroup.notify(queue: .main) {
            parseCryptoInfo()
        }
    }

    public func parseCryptoInfo() {
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
        print("Prasing")
        let cryptoPrices = UserDefaults.standard.dictionary(forKey: "Prices")!
        let priceChanges = UserDefaults.standard.dictionary(forKey: "PriceChanges")!
        var exchangeTotals: [String: Double] = [:]
        var exchangeDailyPL: [String: Double] = [:]
        var overalls: [String: Double] = [:]
        exchanges.forEach {
            exchangeName in
            if let data = (UserDefaults.standard.dictionary(forKey: "\(exchangeName)Data")) {
                var totalForExchange = 0.0
                var dailyPLForExchange = 0.0
                print(exchangeName)
                print(data)
                cryptoInfo[exchangeName] = data.compactMap { symbol, value in
                    let val = value as! Double
                    let price = val * (cryptoPrices[symbol, default: 0.0] as! Double)
                    overalls[symbol] = overalls[symbol] ?? 0 + val
                    totalForExchange += price
                    if (priceChanges[symbol] as! Double) != 0.0 {
                        dailyPLForExchange += price * (priceChanges[symbol, default: 0.0] as! Double) / 100
                    }
                    let cryptoIn = CryptoInfo(
                        name: symbol,
                        balance: roundDoubles(val: price),
                        amount: roundDoubles(val: val),
                        price: cryptoPrices[symbol, default: 0.0] as! Double,
                        dailyProfitLoss: priceChanges[symbol, default: 0.0] as! Double
                    )
                    return cryptoIn
                }
                exchangeDailyPL[exchangeName] = dailyPLForExchange
                exchangeTotals[exchangeName] = totalForExchange
            }
        }
        cryptoInfo["Overall"] = overalls.compactMap { symbol, values in
            CryptoInfo(name: symbol, balance: roundDoubles(val: cryptoPrices[symbol] as! Double * values), amount: roundDoubles(val: values), price: cryptoPrices[symbol] as! Double, dailyProfitLoss: priceChanges[symbol] as! Double)
        }
        infoBoxes = exchangeTotals.compactMap {
            name, value in
            if UserDefaults.standard.value(forKey: "\(name)HistoricData") == nil {
                saveDataToUserDefaults(key: "\(name)HistoricData", data: value)
            }
            let netprofitLoss = Double(UserDefaults.standard.integer(forKey: "\(name)HistoricData")) - value
            let netProfitLossPercentage = (Double(UserDefaults.standard.integer(forKey: "\(name)HistoricData")) / value) - 1
            let dailyProfitLossPercentage = ((value - exchangeDailyPL[name]!) / value) - 1
            print(dailyProfitLossPercentage)
            return InfoBox(
                name: name,
                totalBalance: value,
                dailyProfitLoss: exchangeDailyPL[name]!,
                netProfitLoss: netprofitLoss,
                dailyProfitLossPercentage: dailyProfitLossPercentage,
                netProfitLossPercentage: netProfitLossPercentage
            )
        }
        var overallProfitLoss = 0.0
        var overallDailyProfitLoss = 0.0
        var overallSum = 0.0
        infoBoxes.forEach {
            infobox in
            overallProfitLoss += infobox.netProfitLoss
            overallSum += infobox.totalBalance
            overallDailyProfitLoss += infobox.dailyProfitLoss
        }
        let netProfitLossPercentage = ((overallSum - overallProfitLoss) / overallSum) - 1
        let dailyProfitLossPercentage = ((overallSum - overallDailyProfitLoss) / overallSum) - 1
        if overallSum != 0.0 {
            infoBoxes.insert(
                InfoBox(name: "Overall", totalBalance: overallSum, dailyProfitLoss: overallDailyProfitLoss, netProfitLoss: overallProfitLoss, dailyProfitLossPercentage: dailyProfitLossPercentage,
                        netProfitLossPercentage: netProfitLossPercentage),
                at: 0
            )
        } else {
            noData = true
            print("Sum is zero")
        }
    }

    private func getCryptoInfoForExchange(exchange: String) -> [CryptoInfo] {
        var info = cryptoInfo[exchange]
        while info == nil {
            info = cryptoInfo[exchange]
            sleep(1)
        }
        return info!
    }
}
