//
//  SignInView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/10/23.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        if authViewModel.isSignedIn {
            // Segue to list of all user messages on successful login/signup
            ChatListView()
        } else {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Sign In view image
                        Image(systemName: "message.circle.fill")
                            .font(.system(size: 150))
                            .padding(.top, 80)
                            .padding(.bottom, 40)
                        
                        Group {
                            // Get email from user
                            TextField("Email", text: $authViewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            // Get password from user
                            SecureField("Password", text: $authViewModel.password)
                        }
                        .padding(15)
                        .background(.white)
                        
                        VStack {
                            // Sign In Button
                            Button(action: authViewModel.handleSignIn) {
                                Text("Sign in")
                                    .font(.headline)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(15)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(40)
                            
                            HStack {
                                Text("Don't have an account?")
                                // Sign Up Button
                                NavigationLink(destination: SignUpView(authViewModel: authViewModel)) {
                                    Text("Sign Up")
                                }
                            }
                        }
                        .padding(15)
                        
                        // Error status message
                        /*Text(authViewModel.errorStatusMessage)
                            .foregroundColor(.red)*/
                    }
                    .padding()
                }
                .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
                // Error status message alert
                .alert(isPresented: $authViewModel.isShowingErrorAlert) {
                    Alert(
                        title: Text("Error 🙁"),
                        message: Text(authViewModel.errorStatusMessage),
                        dismissButton: .default(Text("Ok"), action: {
                            authViewModel.isShowingErrorAlert = false
                        })
                    )
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
