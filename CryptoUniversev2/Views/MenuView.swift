import SwiftUI

struct MenuView: View {
    
    @ObservedObject var loginService = LoginService.shared
    
    var body: some View {
        if !loginService.token.isEmpty {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: AddCryptoExchangeView()){
                        Image(systemName: "plus.square")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                        Text("Add Cryptoexchange")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                }
                .padding(.top, 100)
                HStack {
                    Image(systemName: "list.clipboard")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("My Cryptoexchanges")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .padding(.top, 30)
                HStack {
                    NavigationLink(destination: HelpView()){
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                        Text("Help")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                }
                .padding(.top, 30)
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Settings")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .padding(.top, 30)
                Button (action: {self.loginService.token = ""}){
                    HStack {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)){
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                        Text("Log Out")
                            .foregroundColor(.gray)
                            .font(.headline)
                        }
                    }
                }
                .padding(.top, 30)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 32/255, green: 32/255, blue: 32/255))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
//    func logout(){
//        PresentationLink(destination: ContentView()) {
//                    EmptyView()
//                }
//    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
