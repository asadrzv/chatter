//
//  LoginView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/10/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()

    var body: some View {
        if loginViewModel.isLoggedIn {
            // Segue to list of all user messages on successful login/signup
            ChatListView()
        } else {
            // Display login/signup view
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Login view image
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 100))
                            .padding(.bottom, 40)
                        
                        // Username/password fields
                        Group {
                            // Get email from user
                            TextField("Email", text: $loginViewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            // Get password from user
                            SecureField("Password", text: $loginViewModel.password)
                        }
                        .padding(15)
                        .background(.white)
                        
                        // Login/Create Account butttons
                        VStack {
                            // Login Button
                            Button(action: loginViewModel.handleLogin) {
                                Text("Login")
                                    .font(.headline)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(15)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(40)
                            
                            // Create Account Button
                            Button(action: loginViewModel.handleCreateAccount) {
                                Text("Create Account")
                                    .font(.headline)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(15)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(40)
                        }
                        .padding(15)
                        
                        // Login status message
                        Text(loginViewModel.loginStatusMessage)
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
