//
//  User.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/12/23.
//

import Foundation

struct User: Identifiable {
    var id: String
    var email: String
    var name: String
    
    // Dictionary Key-Value pair for storing user data in Firebase
    var dictionary: [String: Any] {
        return [
            "id": id,
            "email": email,
            "name": name
        ]
    }
}

let SAMPLE_USER = User(id: "sampleUserID",
                       email: "sampleUser@gmail.com",
                       name: "sampleUserName")
