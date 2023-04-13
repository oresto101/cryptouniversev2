import SwiftUI

struct MenuView: View {
    var body: some View {
        ZStack {
            Color("MainColor").ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: AddCryptoExchangeView()) {
                        Image(systemName: "plus.square")
                            .foregroundColor(Color("BackgroundColor"))
                            .imageScale(.large)
                        Text("Add Cryptoexchange")
                            .foregroundColor(Color("BackgroundColor"))
                            .font(.headline)
                    }
                }
                .padding(.top, 100)
                HStack {
                    NavigationLink(destination: AddCryptoCurrencyView()) {
                        Image(systemName: "plus.square")
                            .foregroundColor(Color("BackgroundColor"))
                            .imageScale(.large)
                        Text("Add Cryptocurrency")
                            .foregroundColor(Color("BackgroundColor"))
                            .font(.headline)
                    }
                }
                .padding(.top, 30)
                HStack {
                    NavigationLink(destination: HelpView()) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color("BackgroundColor"))
                            .imageScale(.large)
                        Text("Help")
                            .foregroundColor(Color("BackgroundColor"))
                            .font(.headline)
                    }
                }
                .padding(.top, 30)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
