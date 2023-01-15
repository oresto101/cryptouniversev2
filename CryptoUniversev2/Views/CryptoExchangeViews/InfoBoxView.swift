//
//  InfoBoxView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 11/12/2022.
//

import SwiftUI

struct InfoBoxView: View {
    
    var infobox: InfoBox
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .padding()
            .frame(width: 350.0, height: 250.0)
            .foregroundColor(Color("MainColor"))
            .overlay(
                VStack(){
                    HStack{
                        Text(infobox.name)
                            .font(.headline)
                            .fontWeight(.bold)
                        if (infobox.name != "Overall"){
                            Menu{
                                Button(action:{ HomeView().removeCryptoExchange(id: getExchangeByName(name: infobox.name).id)
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
                            Text("Total balance")
                            Text("Daily P/L")
                            Text("Total P/L")
                        }
                        .offset(x: -30.0)
                        VStack(alignment: .trailing){
                            Text(String(roundDoubles(val: infobox.totalBalance)))
                            Text(formatBalancePLAndPercentageToString(balance: infobox.dailyProfitLoss,
                                                                      percentage: infobox.dailyProfitLossPercentage))
                            Text(formatBalancePLAndPercentageToString(balance: infobox.netProfitLoss,
                                                                      percentage: infobox.netProfitLossPercentage))
                        }
                        .offset(x: 30.0)
                    }
                }
            )

    }
}

struct InfoBoxView_Previews: PreviewProvider {
    static var previews: some View {
        InfoBoxView(infobox: InfoBox(name: "Overall", totalBalance: 1000, dailyProfitLoss: 100, netProfitLoss: 100, dailyProfitLossPercentage: 100, netProfitLossPercentage: 100))
    }
}
