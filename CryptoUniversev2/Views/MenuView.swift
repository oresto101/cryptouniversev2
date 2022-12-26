import SwiftUI

struct MenuView: View {
    
    @ObservedObject var loginService = LoginService.shared
    
    var body: some View {
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
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Log Out")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            .isHidden(loginService.token.isEmpty, remove: loginService.token.isEmpty)
            HStack {
                NavigationLink(destination: LoginView()){
                    Image(systemName: "arrow.right.to.line")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Log In")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            .isHidden(!loginService.token.isEmpty, remove: !loginService.token.isEmpty)
            HStack {
                NavigationLink(destination: RegistrationView()){
                    Image(systemName: "person.fill.badge.plus")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Register")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            .isHidden(!loginService.token.isEmpty, remove: !loginService.token.isEmpty)
            Spacer()
        }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 32/255, green: 32/255, blue: 32/255))
            .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
