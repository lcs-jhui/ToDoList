//
//  ListVIew.swift
//  ToDoList
//
//  Created by Justin Hui on 4/4/2023.
//

import Blackbird
import SwiftUI

struct ListView: View {
    
    //MARK: Stored Properties
    
    //The list of items to be completed
    @BlackbirdLiveModels ({ db in
        try await TodoItem.read(from: db)
    }) var todoItems
    
    //The iten currently being added
    @State var newItemDescription: String = ""
    
    //MARK: Computed Properties
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                HStack{
                    
                    TextField("Enter a to-do item", text: $newItemDescription)
                    
                    Button(action: {
//                        //Get last todo item id
//                        let lastId = todoItems.last!.id
//
//                        //Create new todo item id
//                        let newID = lastId + 1
//
//                        //Create the new todo item
//                        let newTodoItem = TodoItem(id: newID, description: newItemDescription, completed: false)
//
//                        //Add the new to-do item to the list
//                        todoItems.append(newTodoItem)
//
//                        //Clear the input field
//                        newItemDescription = ""
//
                    }, label: {
                        Text("ADD")
                            .font(.caption)
                    })
                }
                .padding()
                
                List (todoItems.results) { currentItem in
                    
                    Label(title: {
                        Text(currentItem.description)
                    }, icon: {
                        if currentItem.completed == true {
                            Image(systemName: "checkmark.circle")
                        } else {
                            Image(systemName: "circle")
                        }
                    })
                    
                }
            }
            .navigationTitle("To Do")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
