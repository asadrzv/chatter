//
//  ChatListView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/11/23.
//

import SwiftUI

struct ChatListView: View {
    @ObservedObject var chatListViewModel = ChatListViewModel()
            
    var body: some View {
        NavigationView {
            // List of all user chats
            List(chatListViewModel.filteredUsers) { user in
                NavigationLink(destination: {
                    ChatView(otherUser: user)
                }) {
                    ChatCellView(otherUser: user)
                }
            }
            .toolbar {
                /*ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Compose new chat button
                    Button(action: chatListViewModel.handleComposeNewChat) {
                        Image(systemName: "square.and.pencil")
                    }
                }*/
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    // Sign out button
                    Button(action: chatListViewModel.handleSignOut) {
                        Text("Sign out")
                    }
                }
            }
            // Search bar for user to filter chats by user name
            .searchable(text: $chatListViewModel.searchText, prompt: "Search for users by email")
            .listStyle(.plain)
            .navigationTitle("Messages")
        }
        // Pull up sheet to view list of all users to compose new chat to
        .sheet(isPresented: $chatListViewModel.isShowingNewChatView) {
            //NewChatView()
            Text("New Chat View")
        }
        // Segue back to Login View if user successfully logged out
        .fullScreenCover(isPresented: $chatListViewModel.isSignedOut) {
            SignInView()
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
