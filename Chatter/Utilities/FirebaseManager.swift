//
//  FirebaseManager.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/11/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager: NSObject {
    let auth: Auth
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
