//
//  ArkaBreak
//  Created by Enzo & M on 18/04/2025.

//  Fichier ArkaBreakApp.swift


import SwiftUI

@main
struct ArkaBreakApp: App {
    @State private var showLaunchScreen = true

    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView(showLaunchScreen: $showLaunchScreen)
            } else {
                HomeView()
            }
        }
    }
}


/*
import SwiftUI

@main
struct ArkaBreakApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
*/
