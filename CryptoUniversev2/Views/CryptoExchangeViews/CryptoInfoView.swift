//
//  CryptoInfoView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 12/12/2022.
//

import SwiftUI

struct CryptoInfoView: View {
    
    var cryptoInfo: CryptoInfo
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .frame(width: 320.0, height: 75.0)
            .foregroundColor(Color(.green))
            .overlay(
                VStack(){
                    Text(cryptoInfo.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    HStack(){
                        VStack(alignment: .leading){
                            Text("Total balance: ")
                            Text("Amount:  ")
                        }
                        .offset(x: -20.0)
                        VStack(alignment: .trailing){
                            Text(String(cryptoInfo.balance) + " (" + formatPercentageToString(percentage: cryptoInfo.dailyProfitLoss) + ")")
                            Text(String(cryptoInfo.amount))
                        }
                        .offset(x: 20.0)
                    }
                    .font(.subheadline)
                    
                }
            )
    }
}

struct CryptoInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoInfoView(cryptoInfo: CryptoInfo(id: 1, name: "Ethereum", balance:10000.0, amount:1000.0, totalValue: 1000.0, dailyProfitLoss: -100))
    }
}
