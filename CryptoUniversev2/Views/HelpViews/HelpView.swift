//
//  HelpView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 12/12/2022.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .frame(width: 320.0, height: 75.0)
            .foregroundColor(Color(.green))
            .overlay(
                VStack(alignment: .center){
                    Text("This app doesn't have any users so no FAQ for you!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                }
            )
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
