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
            // Search bar for user to filter chats by user name
            .searchable(text: $chatListViewModel.searchText)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Compose new chat button
                    Button(action: chatListViewModel.handleComposeNewChat) {
                        Image(systemName: "square.and.pencil")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    // Logout button
                    Button(action: chatListViewModel.handleLogout) {
                        Text("Log out")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Messages")
        }
        // Pull up sheet to view list of all users to compose new chat to
        .sheet(isPresented: $chatListViewModel.isShowingNewChatView) {
            NewChatView()
        }
        // Segue back to Login View if user successfully logged out
        .fullScreenCover(isPresented: $chatListViewModel.isLoggedOut) {
            LoginView()
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
