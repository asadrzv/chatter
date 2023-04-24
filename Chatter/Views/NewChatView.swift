//
//  NewChatView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/21/23.
//

import SwiftUI

struct NewChatView: View {
    @ObservedObject var newChatViewModel = NewChatViewModel()

    var body: some View {
        NavigationView {
            // List of all user to chat with
            List(newChatViewModel.users) { user in
                NavigationLink(destination: {
                    // Segue to new chat view
                    ChatView(otherUser: user)
                }) {
                    // User profile image
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(5)
                    
                    // Username text
                    Text(user.name)
                        .fontWeight(.bold)
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Message")
        }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
    }
}
