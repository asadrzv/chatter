//
//  ChatterApp.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/10/23.
//

import SwiftUI
import FirebaseCore

@main
struct ChatterApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
