//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Justin Hui on 4/4/2023.
//

import Blackbird
import SwiftUI

@main
struct ToDoListApp: App {
    var body: some Scene {
        WindowGroup {
            ListView()
            //Make the database avaiable to all other views through the environment
                .environment(\.blackbirdDatabase, AppDatabase.instance)
        }
    }
}
