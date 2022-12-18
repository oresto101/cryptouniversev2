//
//  LoginView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 17/12/2022.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var loginService = LoginService.shared
    @State private var username: String = ""
    @State private var password: String = ""
    @ObservedObject var network = Network.shared
    var body: some View {
        VStack{
            Spacer()
            Text("Please log in!")
            List {
                Section{
                    TextField(
                        "User name (email address)",
                        text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    SecureField(
                        "Password",
                        text: $password
                    )
                }
                Button("Log in") {
                    loginService.login(username: username, password: password)
                    network.callToGetCryptoInfo()
                    network.callToGetInfoBoxes()
                }
                .disabled(username.isEmpty || password.isEmpty)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
