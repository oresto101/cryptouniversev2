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
    @ObservedObject var network = NetworkService.shared

    error in
      guard let data = data else {
        print(String(describing: error))
        semaphore.signal()
        return
      }
