//
//  LoginView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/10/23.
//

import SwiftUI

struct LoginView: View {
    @State private var isLoggedIn = false
    @State private var loginStatusMessage = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        if isLoggedIn {
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
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            // Get password from user
                            SecureField("Password", text: $password)
                        }
                        .padding(15)
                        .background(.white)
                        
                        // Login/Create Account butttons
                        VStack {
                            // Login Button
                            Button(action: handleLogin) {
                                Text("Login")
                                    .font(.headline)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(15)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(40)
                            
                            // Create Account Button
                            Button(action: handleCreateAccount) {
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
                        Text(self.loginStatusMessage)
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            }
        }
    }
    
    // MARK: - Action Handlers
    
    // Login user on button press
    private func handleLogin() {
        loginUser()
    }
    
    // Create account on button press
    private func handleCreateAccount() {
        createUser()
    }
    
    // MARK: - Firebase
    
    // Login user to Firebase Auth using specified credentials
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                // Failed to login user
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err.localizedDescription)"
            } else {
                // Succesfully logged in user
                storeUserInformation()
                self.isLoggedIn = true
                self.loginStatusMessage = "Succesfully logged in as user: \(result?.user.uid ?? "")"
                print("Succesfully logged in as user: \(result?.user.uid ?? "")")
            }
        }
    }
    
    // Create user to Firebase Auth using specified credentials
    private func createUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                // Failed to create user
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err.localizedDescription)"
            } else {
                // Succesfully created user
                storeUserInformation()
                self.isLoggedIn = true
                self.loginStatusMessage = "Succesfully created user: \(result?.user.uid ?? "")"
                print("Succesfully created user: \(result?.user.uid ?? "")")
            }
        }
    }
    
    // Store user credentials to Firebase Firestore
    private func storeUserInformation() {
        // Create user data (key-value pair) to store in collection if user doesn't exist
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = User(email: self.email).dictionary
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    // Failed to store user data
                    print("Failed to store user data:", err)
                    self.loginStatusMessage += "\n\nFailed to store user data: \(err.localizedDescription)"
                } else {
                    // Succesfully stored user data
                    print("Succesfully stored data for user: \(uid)")
                }
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
