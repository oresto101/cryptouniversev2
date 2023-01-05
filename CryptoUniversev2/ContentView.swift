import SwiftUI

struct ContentView: View {
    @State private var loginFail = false
    @State private var userVerified = false
    @State private var registration = false
    @State private var registrationFail = false
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    @ObservedObject var loginService = LoginService.shared
    @ObservedObject var registrationService = RegistrationService.shared
    
    
    var body: some View {
        if userVerified && !(loginService.token=="") {
            MainView()
        }else if registration{
            registrationPage
        }else{
            loginPage
        }
    }
    
    var loginPage : some View{
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            Text("Log In")
                .foregroundColor(.black)
                .font(.system(size: 40, weight: .bold))
            TextField("Username", text: self.$username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: self.$password)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .privacySensitive()
                    HStack {
                        Spacer()
                        Button("Register!"){
                            registration = true
                        }
                        .tint(.red.opacity(0.80))
                        Spacer()
                        Button("Log In",role: .cancel){
                            loginService.login(username: username, password: password)
                            if loginService.token != ""{
                                userVerified=true
                                loginFail=false
                            }else{
                                loginFail=true
                            }
                        }
                        .disabled(username.isEmpty ||  password.isEmpty)
                        .buttonStyle(.bordered)
                        Spacer()
                        }
                    Spacer()
        }
        .alert("Access denied", isPresented: self.$loginFail) {
            Button("Dismiss"){
            }
        }
        .frame(width: 300)
        .padding()
    }
    
    var registrationPage : some View{
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            Text("Registration")
                .foregroundColor(.black)
                .font(.system(size: 40, weight: .bold))
            TextField("Username", text: self.$username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
            TextField("Email", text: self.$email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: self.$password)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .privacySensitive()
            SecureField("Repeat Password", text: self.$repeatedPassword)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .privacySensitive()
            HStack {
                Spacer()
                Button("Log In!"){
                    registration = false
                }
                .tint(.red.opacity(0.80))
                Spacer()
                Button("Register") {
                    registrationService.register(username: username, password: password, email: email)
                    if !registrationService.fail{
                        registration = false
                    }else{
                        registrationFail = true
                    }
                }
                .disabled(username.isEmpty || email.isEmpty || password.isEmpty || password != repeatedPassword)
                .buttonStyle(.bordered)
                Spacer()
                }
            Spacer()
        }
        .alert("Registration Failed", isPresented: self.$registrationFail) {
            Button("Dismiss"){
            }
        }
        .frame(width: 300)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

