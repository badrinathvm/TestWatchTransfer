//
//  ConnectivityApp.swift
//  Connectivity Watch App
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI

@main
struct Connectivity_Watch_AppApp: App {
    init() {
        // Initialize WatchConnectivity
        _ = WatchConnectivityManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
           // WatchContentView()
            CounterSubmitView()
        }
    }
}
