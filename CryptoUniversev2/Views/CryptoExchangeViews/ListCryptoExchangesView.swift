//
//  ListCryptoExchangesView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 26/12/2022.
//

import SwiftUI

struct ListCryptoExchangesView: View {
    
    @ObservedObject var network = NetworkService.shared
    @ObservedObject var cryptoExchangeManagementService = CryptoExchangeManagementService.shared
    
    var body: some View {
        if network.getInfoBoxes().isEmpty{
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 320.0, height: 75.0)
                .foregroundColor(Color(.green))
                .overlay(
                    VStack(){
                        Text("Please add a cryptoexchange")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                )
        }
        else{
            ScrollView{
                ForEach(network.getInfoBoxes(), id: \.self) {infobox in InfoBoxView(infobox: infobox)
                        .contextMenu()
                    {
                        Button(action: { cryptoExchangeManagementService.removeCryptoExchange(id: getExchangeByName(name: infobox.name).id) } ) {
                        Text("Remove exchange")
                        }
                    }
                }
            }
        }
    }
}

struct ListCryptoExchangesView_Previews: PreviewProvider {
    static var previews: some View {
        ListCryptoExchangesView()
    }
}
