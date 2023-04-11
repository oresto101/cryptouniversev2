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
            if infoBoxes != nil && cryptoInfo != nil {
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
        return ScrollView(showsIndicators: false) {
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
            if !loadingBoxes && !loadingInfo {
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
            if infobox.name != "Overall" && infobox.name != "Manual" {
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

    private func loadDefaults() {
        if UserDefaults.standard.object(forKey: "infoBoxes") != nil && UserDefaults.standard
            .object(forKey: "cryptoInfo") != nil
        {
            cryptoInfo = parseCryptoInfo(json: UserDefaults.standard.object(forKey: "cryptoInfo") as! Data)
            infoBoxes = parseInfoBox(json: UserDefaults.standard.object(forKey: "infoBoxes") as! Data)
        }
    }

    private func loadData() {
        if infoBoxes == nil || cryptoInfo == nil {
            let tstCryptoInfo = """
            {
                "Overall": [
                    {
                        "name": "OAS",
                        "amount": 165.46437,
                        "price": 0.09154860630755665,
                        "balance": 15.15,
                        "dailyProfitLoss": 0.0
                    },
                ],
                "OKX": [
                    {
                        "name": "OAS",
                        "amount": 165.46437,
                        "price": 0.09154860630755665,
                        "balance": 15.15,
                        "dailyProfitLoss": 0
                    },
                    {
                        "name": "USDT",
                        "amount": 12.02116,
                        "price": 1,
                        "balance": 12.02,
                        "dailyProfitLoss": 0.0
                    }
                ],
                "Kraken": [
                    {
                        "name": "USDT",
                        "amount": 9.2,
                        "price": 1,
                        "balance": 9.2,
                        "dailyProfitLoss": 0.0
                    },
                    {
                        "name": "MATIC",
                        "amount": 6.13005,
                        "price": 1.128,
                        "balance": 6.91,
                        "dailyProfitLoss": 0.0
                    }
                ],
                "Manual": [
                    {
                        "name": "SOL",
                        "amount": 6.0,
                        "price": 22.79,
                        "balance": 136.74,
                        "dailyProfitLoss": 0.02
                    }
                ]
            }
            """
            let tstInfoBoxes = """
            [
                {
                    "name": "Overall",
                    "totalBalance": 181.95999999999998,
                    "dailyProfitLoss": 0.02,
                    "netProfitLoss": -3.1199205458445824,
                    "dailyProfitLossPercentage": 0.010991426687183998,
                    "netProfitLossPercentage": -1.6857153043091853
                },
                {
                    "name": "OKX",
                    "totalBalance": 27.17,
                    "dailyProfitLoss": 0.0,
                    "dailyProfitLossPercentage": 0.0,
                    "netProfitLoss": 0.05000000000000071,
                    "netProfitLossPercentage": 0.18436578171091708
                },
                {
                    "name": "Kraken",
                    "totalBalance": 16.13,
                    "dailyProfitLoss": 0.0,
                    "dailyProfitLossPercentage": 0.0,
                    "netProfitLoss": 2.1499999999999986,
                    "netProfitLossPercentage": 15.379113018597987
                },
                {
                    "name": "Manual",
                    "totalBalance": 138.66,
                    "dailyProfitLoss": 0.02,
                    "dailyProfitLossPercentage": 0.014423770373575652,
                    "netProfitLoss": -5.319920545844582,
                    "netProfitLossPercentage": -3.694904487845351
                }
            ]
            """
            cryptoInfo = parseCryptoInfo(json: tstCryptoInfo.data(using: .utf8)!)
            infoBoxes = parseInfoBox(json: tstInfoBoxes.data(using: .utf8)!)
        }
    }

    private func updateData() {
        print("Updating")
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
