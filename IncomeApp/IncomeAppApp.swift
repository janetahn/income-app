//
//  IncomeAppApp.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-25.
//

import SwiftUI

@main
struct IncomeAppApp: App {
    
    let dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
