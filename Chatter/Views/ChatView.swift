//
//  ChatView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/13/23.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    let otherUser: User
    
    private let columns = [GridItem(.flexible(minimum: 10))]
    @FocusState private var isFocused
    
    static let scrollToBottomPlaceholder = "" // Share scroll string with all messages
    
    init(otherUser: User) {
        self.otherUser = otherUser
        self.chatViewModel = ChatViewModel.init(otherUser: otherUser)
    }

    var body: some View {
        VStack {
            // Chat messsage bubbles between users with auto scroll to latest messge
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(chatViewModel.messages) { message in
                            MessageView(message: message)
                        }
                        .padding(.horizontal)
                        
                        // Empty spacer at bottom of view to auto scroll to
                        HStack {
                            Spacer()
                        }
                        .id(Self.scrollToBottomPlaceholder)
                    }
                    // Auto scroll to latest chat message when message count increases
                    .onReceive(chatViewModel.$messageCount) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.scrollToBottomPlaceholder, anchor: .bottom)
                        }
                    }
                }
            }
            // Botoom tool bar view to type/send new message
            getToolBarView()
        }
        .padding(.top, 1)
        .navigationTitle(chatViewModel.otherUser?.email ?? "Unknown")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Custom Views
    
    // Return Toolbar view for user to type new message to send
    private func getToolBarView() -> some View {
        VStack {
            HStack {
                // Get message to send from user
                TextField("Message", text: $chatViewModel.messageText)
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .focused($isFocused)
                
                // Send messsage button
                Button(action: chatViewModel.handleSendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle()
                            // Set send message button to gray (nothing to send) or blue (text to send)
                            .foregroundColor(chatViewModel.messageText.isEmpty ? .gray : .blue)
                        )
                }
                .disabled(chatViewModel.messageText.isEmpty)
            }
            .frame(height: 40)
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(.thickMaterial)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(otherUser: SAMPLE_USER)
    }
}
