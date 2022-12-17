//
//  HelpView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 12/12/2022.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView (showsIndicators: false) {
            LazyVStack {
                ForEach(1...10, id: \.self) { count in
                    Text("Helpfield " + String(count))
                }
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
