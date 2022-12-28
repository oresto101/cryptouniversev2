//
//  ContentView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 10/12/2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var network = NetworkService.shared
    @State var showMenu = false
    @State var refreshes = true
    
    var body: some View {
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {
                                self.showMenu = false
                            }
                        }
                    }
                
                return NavigationView {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            MainView(showMenu: self.$showMenu)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .offset(x: self.showMenu ? geometry.size.width*3/4 : 0)
                                .disabled(self.showMenu ? true : false)
                                .onAppear {
                                    self.showMenu = false
                                }
                            if self.showMenu {
                                MenuView()
                                    .frame(width: geometry.size.width*3/4)
                                    .transition(.move(edge: .leading))
                            }
                        }
                            .gesture(drag)
                    }
                        .navigationBarTitle("Crypto Universe", displayMode: .inline)
                        .navigationBarItems(leading: (
                            Button(action: {
                                withAnimation {
                                    self.showMenu.toggle()
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .imageScale(.large)
                            }
                        ))
                }
                .refreshable(){
                    self.loadData()
                }
    }
    
    func loadData() -> Void {
        self.network.callToGetInfoBoxes()
        sleep(2)
        self.network.callToGetCryptoInfo()
        sleep(6)
        refreshes = !refreshes
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NetworkService())
    }
}

struct MainView: View {
    
    @ObservedObject var loginService = LoginService.shared
    @ObservedObject var network = NetworkService.shared
    
    @Binding var showMenu: Bool
    
    var body: some View {
        TabView(){
            ScrollView{
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 320.0, height: 75.0)
                    .foregroundColor(Color(.green))
                    .overlay(
                        VStack(){
                            if loginService.token.isEmpty {
                                Text("Please log in to see your assets!")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            else{
                                Text("No data please refresh the page or add new cryptoexchange")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                    )
                }
            .isHidden(!network.infoBoxes.isEmpty, remove: !network.infoBoxes.isEmpty)
                ForEach(network.getInfoBoxes(), id: \.self) { infobox in
                    CryptoExchangeView(infobox: infobox, cryptoInfo: network.getCryptoInfoForExchange(exchange: infobox.name))
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
