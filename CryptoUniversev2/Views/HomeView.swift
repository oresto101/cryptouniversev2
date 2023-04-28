import SwiftUI

struct HomeView: View {
    @State private var infoBoxes: [InfoBox]?
    @State private var cryptoInfo: [String: [CryptoInfo]]?
    @State private var loadingBoxes = false
    @State private var loadingInfo = false

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
                loadingProgressView
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
                        removeCryptoExchange(id: getExchangeByName(name: infobox.name).id, infobox: infobox)
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

    var loading_view: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1))
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }.frame(width: 30, height: 30, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
    }

    func removeCryptoExchange(id _: String, infobox _: InfoBox) {}

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
        if infoBoxes == nil || cryptoInfo == nil {
            cryptoInfo = [:]
            infoBoxes = []
            parseCryptoInfo()
        }
    }
    
    private func getData() {
    }
    private func updateData() {
        parseCredentials()
        print("Updating")
        print(UserDefaults.standard.dictionary(forKey: "BinanceData") as Any)
        print(UserDefaults.standard.integer(forKey: "BinanceHistoricData") as Any)
        parseCryptoInfo()
        
    }
    
    private func parseCryptoInfo() {
        let cryptoPrices = UserDefaults.standard.dictionary(forKey: "CurrentPrices")!
        let priceChanges = UserDefaults.standard.dictionary(forKey: "PriceChanges")!
        var exchangeTotals:[String: Double] = [:]
        var exchangeDailyPL: [String: Double] = [:]
        var overalls:[String: Double] = [:]
        exchanges.forEach {
            exchangeName in
            if let data = (UserDefaults.standard.dictionary(forKey: "\(exchangeName)Data")){
                var totalForExchange = 0.0
                var dailyPLForExchange = 0.0
                cryptoInfo![exchangeName] = data.compactMap { (symbol, values) in
                    let arr = values as! [Double]
                    overalls[symbol] = overalls[symbol] ?? 0 + arr[0]
                    totalForExchange += arr[1]
                    if ((priceChanges[symbol]as! Double) != 0.0){
                        dailyPLForExchange += arr[1]/(priceChanges[symbol] as! Double)
                    }
                    let cryptoIn = CryptoInfo(name: symbol, balance: roundDoubles(val: arr[1]), amount: roundDoubles(val: arr[0]), price: cryptoPrices[symbol] as! Double, dailyProfitLoss: priceChanges[symbol] as! Double)
                    return cryptoIn
                }
                exchangeDailyPL[exchangeName] = dailyPLForExchange
                exchangeTotals[exchangeName] = totalForExchange
            }
        }
        cryptoInfo!["Overall"] = overalls.compactMap{(symbol, values) in
            return CryptoInfo(name: symbol, balance: cryptoPrices[symbol] as! Double * values, amount: values, price: cryptoPrices[symbol] as! Double, dailyProfitLoss: priceChanges[symbol] as! Double)
        }
        infoBoxes = exchangeTotals.compactMap{
            (name, value ) in
            let netprofitLoss = Double(UserDefaults.standard.integer(forKey: "\(name)HistoricData")) - value
            let netProfitLossPercentage = (Double(UserDefaults.standard.integer(forKey: "\(name)HistoricData"))/value) - 1
            let dailyProfitLossPercentage = ((value - exchangeDailyPL[name]!)/value)-1
            print(dailyProfitLossPercentage)
            return InfoBox(name: name, totalBalance: value, dailyProfitLoss: exchangeDailyPL[name]!, netProfitLoss: netprofitLoss, dailyProfitLossPercentage: dailyProfitLossPercentage, netProfitLossPercentage: netProfitLossPercentage)
        }
        var overallProfitLoss = 0.0
        var overallDailyProfitLoss = 0.0
        var overallSum = 0.0
        infoBoxes?.forEach{
            infobox in
            overallProfitLoss += infobox.netProfitLoss
            overallSum += infobox.totalBalance
            overallDailyProfitLoss += infobox.dailyProfitLoss
        }
        let netProfitLossPercentage = ((overallSum-overallProfitLoss)/overallSum)-1
        let dailyProfitLossPercentage = ((overallSum-overallDailyProfitLoss)/overallSum)-1
        infoBoxes?.insert(InfoBox(name: "Overall", totalBalance: overallSum, dailyProfitLoss: overallDailyProfitLoss, netProfitLoss: overallProfitLoss, dailyProfitLossPercentage: dailyProfitLossPercentage, netProfitLossPercentage: netProfitLossPercentage), at: 0)
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
