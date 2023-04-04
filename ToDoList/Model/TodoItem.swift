//
//  TodoItem.swift
//  ToDoList
//
//  Created by Justin Hui on 4/4/2023.
//

import Blackbird
import Foundation

struct TodoItem: BlackbirdModel {
    @BlackbirdColumn var id: Int
    @BlackbirdColumn var description: String
    @BlackbirdColumn var completed: Bool
}
