//
//  CryptoInfoView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 12/12/2022.
//

import SwiftUI

struct CryptoInfoView: View {
    
    var cryptoInfo: CryptoInfo
    var cryptoExchange: String
    @State private var disabled = false
    @ObservedObject var loginService = LoginService.shared
    
    var body: some View {
        if(!disabled){
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 320.0, height: 75.0)
                .foregroundColor(calculateColorForBox(profitLoss: cryptoInfo.dailyProfitLoss))
                .overlay(
                    VStack(){
                        HStack{
                            Text(cryptoInfo.name)
                                .font(.headline)
                                .fontWeight(.bold)
                            if (cryptoExchange == "Manual"){
                                Menu{
                                    Button(action:{ removeCryptocurrency(name: cryptoInfo.name)
                                    }) {
                                        Label("Delete", systemImage: "minus.circle")
                                    }
                                }label: {
                                    Image("RemoveExchange")
                                }
                            }
                        }
                        HStack(){
                            VStack(alignment: .leading){
                                Text("Total balance: ")
                                Text("Amount:  ")
                            }
                            .offset(x: -20.0)
                            VStack(alignment: .trailing){
                                Text(formatBalancePLAndPercentageToString(balance: cryptoInfo.balance, percentage: cryptoInfo.dailyProfitLoss))
                                Text(String(cryptoInfo.amount))
                            }
                            .offset(x: 20.0)
                        }
                        .font(.subheadline)
                        
                    }
                )
        }
    }
    
    func calculateColorForBox(profitLoss: Double) -> Color {
        if profitLoss>=0 {
            return Color("ProfitColor")
        }
        else {
                return Color("LossColor")
        }
    }
    
    private func removeCryptocurrency(name: String){
        let parameters = "coin="+name
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/wallet/")!,timeoutInterval: Double.infinity)
        request.addValue(loginService.token, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "DELETE"
        request.httpBody = postData

        let _: Void = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                disabled=true
            }
        }.resume()
    }
}

struct CryptoInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoInfoView(cryptoInfo: CryptoInfo(name: "Ethereum", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100), cryptoExchange: "")
    }
}
