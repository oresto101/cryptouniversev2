//
//  RegistrationView.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 26/12/2022.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var registrationService = RegistrationService.shared
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    
    var body: some View {
        VStack{
            Spacer()
            Text("Please register!")
            List {
                Section{
                    TextField(
                        "User name",
                        text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    TextField(
                        "Email address",
                        text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    SecureField(
                        "Password",
                        text: $password
                    )
                    SecureField(
                        "Repeat Password",
                        text: $repeatedPassword
                    )
                }
                Button("Register") {
                    registrationService.register(username: username, password: password, email: email)
                }
                .disabled(username.isEmpty || email.isEmpty || password.isEmpty || password != repeatedPassword)
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
