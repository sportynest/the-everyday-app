//
//  The_Everyday_AppApp.swift
//  The Everyday App
//
//  Created by Lekan Soyewo on 2023-11-19.
//

import SwiftUI

@main
struct The_Everyday_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CalendarManager())
                .environmentObject(LocationManager())
        }
    }
}
