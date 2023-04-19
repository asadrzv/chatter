//
//  Chat.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/13/23.
//

import Foundation

struct Chat: Identifiable {
    // Chat id should match the users
    var id: UUID {
        return otherUser.id
    }
    // Other user chatting with
    let otherUser: User
    // Messages contained in chat
    var messages: [Message]
    // Indicates if user has unread messages in this chat
    var hasUnreadMessages = false
    
    // Dictionary Key-Value pair for storing chat data in Firebase
    var dictionary: [String: Any] {
        //var messagesDict = [String: String]()
        /*for message in messages {
            messagesDict.append(message.dictionary)
        }*/
        
        return [
            "otherUserID": otherUser.id,
            "hasUnreadMessages": hasUnreadMessages
            //"messages": messagesDict
        ]
    }
}


let SAMPLE_CHAT_LIST = [SAMPLE_CHAT_1, SAMPLE_CHAT_2, SAMPLE_CHAT_3, SAMPLE_CHAT_4]

let SAMPLE_USER_1 = User(email: "ash@gmail.com")
let SAMPLE_MESSAGES_1 = [
    Message(date: Date(timeIntervalSinceNow: -86400 * 3), text: "shase bsaj dad uda jadj aiosda as jka kjawj asks aksa ks aksk as ", type: .Sent),
    Message(date: Date(timeIntervalSinceNow: -86400 * 3), text: "shase bsaj dad uda sad asd! saksj aks ak skja", type: .Sent),
    Message(date: Date(timeIntervalSinceNow: -86400 * 2), text: "shaseuda jadj aiosdas.", type: .Received),
    Message(date: Date(), text: "shase bsaj asd asda. as jaks jaks jaksj akjs akjs akj skajs kajs kajs kajs kajk saj sa ", type: .Received)
]
let SAMPLE_CHAT_1 = Chat(otherUser: SAMPLE_USER_1, messages: SAMPLE_MESSAGES_1, hasUnreadMessages: true)

let SAMPLE_USER_2 = User(email: "misty@gmail.com")
let SAMPLE_MESSAGES_2 = [
    Message(date: Date(timeIntervalSinceNow: -86400 * 3), text: "shase bsaj dad uda  sad asd!a ssa sa ssas sas sas sas as as as ", type: .Sent),
    Message(date: Date(timeIntervalSinceNow: -86400 * 2), text: "shase bsaj da djflsdjf ldsfj lasdfjald fj ldfjdf ", type: .Sent),
    Message(date: Date(), text: "shaseuda jadjfld sfjsldf jsdlfj lsdfj lsdjf lsdjf ljdf", type: .Received),
    Message(date: Date(), text: "shase bsaj asd asda. sad asd! djlfldjlf jdlf jd", type: .Received)
]
let SAMPLE_CHAT_2 = Chat(otherUser: SAMPLE_USER_2, messages: SAMPLE_MESSAGES_2, hasUnreadMessages: false)

let SAMPLE_USER_3 = User(email: "brock@gmail.com")
let SAMPLE_MESSAGES_3 = [
    Message(date: Date(timeIntervalSinceNow: -86400 * 3), text: "shase bsaj ddj aiosdas. sad asd!dlfj ldfj ldfj lfjsdl fjsdlfj ", type: .Sent),
    Message(date: Date(timeIntervalSinceNow: -86400 * 3), text: "shase bsajlsdfj lsdfj lsdfj lsdjf", type: .Sent),
    Message(date: Date(timeIntervalSinceNow: -86400 * 2), text: "shaseuda jadj aiosdas. sad asd!", type: .Received),
    Message(date: Date(timeIntervalSinceNow: -86400 * 8), text: "shasd asda. sad asd!", type: .Received)
]
let SAMPLE_CHAT_3 = Chat(otherUser: SAMPLE_USER_3, messages: SAMPLE_MESSAGES_3, hasUnreadMessages: true)

let SAMPLE_USER_4 = User(email: "gary@gmail.com")
let SAMPLE_MESSAGES_4 = [
    Message(date: Date(timeIntervalSinceNow: -86400 * 3), text: "shasdsflj ldsf jdlfj sdlfj lsdfj ldfj lsdf jdlfj", type: .Sent),
    Message(date: Date(timeIntervalSinceNow: -86400 * 3), text: "shase bsaj dad uda sad asd!dsf ljsdfl sdf lsdfj lsdfj dlf", type: .Sent),
    Message(date: Date(timeIntervalSinceNow: -86400 * 2), text: "shaseuda jadj aiosdas. sad asd!", type: .Received)
]
let SAMPLE_CHAT_4 = Chat(otherUser: SAMPLE_USER_4, messages: SAMPLE_MESSAGES_4, hasUnreadMessages: false)
