import SwiftUI

struct MenuView: View {
    
    @ObservedObject var loginService = LoginService.shared
    
    var body: some View {
        ZStack{
            Color("MainColor").ignoresSafeArea()
                VStack(alignment: .leading) {
                    HStack {
                        NavigationLink(destination: AddCryptoExchangeView()){
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
                        NavigationLink(destination: HelpView()){
                            Image(systemName: "info.circle")
                                .foregroundColor(Color("BackgroundColor"))
                                .imageScale(.large)
                            Text("Help")
                                .foregroundColor(Color("BackgroundColor"))
                                .font(.headline)
                        }
                    }
                    .padding(.top, 30)
                    Button (action: {self.loginService.token = ""}){
                        HStack {
                            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)){
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(Color("BackgroundColor"))
                                    .imageScale(.large)
                                Text("Log Out")
                                    .foregroundColor(Color("BackgroundColor"))
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.top, 30)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
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
