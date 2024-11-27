//
//  MacroApp.swift
//  Macro
//
//  Created by Yunki on 9/21/24.
//

import SwiftUI

@main
struct MacroApp: App {
    var router = Router()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(router)
        }
    }
}
