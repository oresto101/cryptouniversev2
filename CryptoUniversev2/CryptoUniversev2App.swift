//
//  CryptoUniversev2App.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 10/12/2022.
//

import SwiftUI

@main
struct CryptoUniversev2App: App {
    @ObservedObject var network = Network.shared
    init(){
        self.loadData()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func loadData() -> Void {
        network.callToGetInfoBoxes()
        network.callToGetCryptoInfo()
        sleep(7)
    }
}
