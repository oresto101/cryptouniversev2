//
//  ContentView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 10/12/2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var network = Network.shared
    @State var showMenu = false
    @State private var showingLoginView = false
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
                                    network.callToGetInfoBoxes()
                                    network.callToGetCryptoInfo()
                                    if network.responseCode == 401 {
                                        showingLoginView = true
                                    }
                                    else {
                                        showingLoginView = false
                                    }
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
                    network.callToGetInfoBoxes()
                    network.callToGetCryptoInfo()
                    if network.responseCode == 401 {
                        showingLoginView = true
                    }
                    else {
                        showingLoginView = false
                    }
                }
                .popover(isPresented: $showingLoginView)
        {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}

struct MainView: View {
    
    @ObservedObject var network = Network.shared
    
    @Binding var showMenu: Bool
    
    var body: some View {
        TabView(){
                ForEach(network.getInfoBoxes(), id: \.self) { infobox in
                    CryptoExchangeView(infobox: infobox, cryptoInfo: network.getCryptoInfoForExchange(exchange: infobox.name))
            }
        }
        .tabViewStyle(PageTabViewStyle())
        
    }
}
