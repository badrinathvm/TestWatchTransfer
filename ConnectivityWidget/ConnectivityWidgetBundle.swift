//
//  ConnectivityWidgetBundle.swift
//  ConnectivityWidget
//
//  Created by Rani Badri on 10/14/25.
//

import WidgetKit
import SwiftUI

@main
struct ConnectivityWidgetBundle: WidgetBundle {
    // Below is not required.
    init() {
        // Initialize WatchConnectivity session when widget extension starts
        _ = WatchConnectivityManager.shared
    }

    var body: some Widget {
        MessageComplicationWidget()
        CounterWidget()
        SubmitWidget()
    }
}
