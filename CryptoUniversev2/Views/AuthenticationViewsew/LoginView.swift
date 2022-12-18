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
    
    var body: some View {
        VStack{
            Text("Please log in!")
            List {
                
                TextField(
                    "User name (email address)",
                    text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                SecureField(
                    "Password",
                    text: $password
                )
                Button("Log in") {
                    loginService.login(username: username, password: password)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
