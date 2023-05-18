import SwiftUI

let dispatchGroup = DispatchGroup()

struct HomeView: View {
    @State private var infoBoxes: [InfoBox]?
    @State private var cryptoInfo: [String: [CryptoInfo]]?
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
            if infoBoxes != nil, cryptoInfo != nil {
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
        ForEach(infoBoxes!, id: \.self) { infobox in
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
                CryptoExchangeView(
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

    private func parseInfoBox(json: Data) -> [InfoBox] {
        let decoder = JSONDecoder()
        do {
            let box = try decoder.decode([InfoBox].self, from: json)
            return box
        } catch {
            return []
        }
    }

    func parseCryptoInfo(json: Data) -> [String: [CryptoInfo]] {
        let decoder = JSONDecoder()
        do {
            let info = try decoder.decode([String: [CryptoInfo]].self, from: json)
            return info
        } catch {
            return [:]
        }
    }

    private func loadData() {
        print("Loading")
        if UserDefaults.standard.dictionary(forKey: "CurrentPrices") == nil || UserDefaults.standard.dictionary(forKey: "PriceChanges") == nil {
            noData = true
            return
        }
        if infoBoxes == nil || cryptoInfo == nil {
            cryptoInfo = [:]
            infoBoxes = []
            parseCredentials()
            dispatchGroup.notify(queue: .main) {
                parseCryptoInfo()
            }

            printDataDebug()
        }
    }

    private func printDataDebug() {
        exchanges.forEach {
            exchangeName in
            if let data = (UserDefaults.standard.dictionary(forKey: "\(exchangeName)Data")) {
                print(exchangeName)
                print(data)
            }
        }
    }

    private func updateData() {
        print("Updating")
        parseCredentials()
        dispatchGroup.notify(queue: .main) {
            parseCryptoInfo()
        }
    }

    private func parseCryptoInfo() {
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
                cryptoInfo![exchangeName] = data.compactMap { symbol, value in
                    let val = value as! Double
                    let price = val * (cryptoPrices[symbol] as! Double)
                    overalls[symbol] = overalls[symbol] ?? 0 + val
                    totalForExchange += price
                    if (priceChanges[symbol] as! Double) != 0.0 {
                        dailyPLForExchange += price * (priceChanges[symbol] as! Double) / 100
                    }
                    let cryptoIn = CryptoInfo(
                        name: symbol,
                        balance: roundDoubles(val: price),
                        amount: roundDoubles(val: val),
                        price: cryptoPrices[symbol] as! Double,
                        dailyProfitLoss: priceChanges[symbol] as! Double
                    )
                    return cryptoIn
                }
                exchangeDailyPL[exchangeName] = dailyPLForExchange
                exchangeTotals[exchangeName] = totalForExchange
            }
        }
        cryptoInfo!["Overall"] = overalls.compactMap { symbol, values in
            CryptoInfo(name: symbol, balance: cryptoPrices[symbol] as! Double * values, amount: values, price: cryptoPrices[symbol] as! Double, dailyProfitLoss: priceChanges[symbol] as! Double)
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
        infoBoxes?.forEach {
            infobox in
            overallProfitLoss += infobox.netProfitLoss
            overallSum += infobox.totalBalance
            overallDailyProfitLoss += infobox.dailyProfitLoss
        }
        let netProfitLossPercentage = ((overallSum - overallProfitLoss) / overallSum) - 1
        let dailyProfitLossPercentage = ((overallSum - overallDailyProfitLoss) / overallSum) - 1
        if overallSum != 0.0 {
            infoBoxes?.insert(
                InfoBox(name: "Overall", totalBalance: overallSum, dailyProfitLoss: overallDailyProfitLoss, netProfitLoss: overallProfitLoss, dailyProfitLossPercentage: dailyProfitLossPercentage,
                        netProfitLossPercentage: netProfitLossPercentage),
                at: 0
            )
        }
    }

    private func getCryptoInfoForExchange(exchange: String) -> [CryptoInfo] {
        var info = cryptoInfo![exchange]
        while info == nil {
            info = cryptoInfo![exchange]
            sleep(1)
        }
        return info!
    }
}
