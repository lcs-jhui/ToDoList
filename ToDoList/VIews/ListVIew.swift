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
    
    //Access the connection to the database (needed to add a new record)
    @Environment (\.blackbirdDatabase) var db: Blackbird.Database?
    
    //The list of items to be completed
    @BlackbirdLiveModels ({ db in
        try await TodoItem.read(from: db, sqlWhere: "description LIKE ?", "%\(searchText)%")
    }) var todoItems
    
    //The item currently being added
    @State var newItemDescription: String = ""
    
    //Curretn search text
    @State var searchText = ""
    
    //MARK: Computed Properties
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                HStack{
                    
                    TextField("Enter a to-do item", text: $newItemDescription)
                    
                    Button(action: {
                        
                        Task {
                            
                            //Write to database
                            try await db!.transaction { core in
                                try core.query("INSERT INTO TodoItem ( description ) VALUES (?)", newItemDescription)
                            }
                            
                            //Clear the input field
                            newItemDescription = ""
                        }
                        
                    }, label: {
                        Text("ADD")
                            .font(.caption)
                    })
                    
                    //Disables the add button when the textfield is empty
                    .disabled(newItemDescription.isEmpty)
                }
                .padding()
                
                List {
                    
                    ForEach (todoItems.results) { currentItem in
                        
                        Label(title: {
                            Text(currentItem.description)
                        }, icon: {
                            if currentItem.completed == true {
                                Image(systemName: "checkmark.circle")
                            } else {
                                Image(systemName: "circle")
                            }
                        })
                        .onTapGesture {
                            Task {
                                try await db!.transaction { core in
                                    //Change the status for this person to the opposite of its current value
                                    try core.query("UPDATE TodoItem SET completed = (?) WHERE id = (?)", !currentItem.completed, currentItem.id)
                                }
                            }
                        }
                    }
                    .onDelete(perform: removeRows)
                    
                }
                .searchable(text: $searchText)
            }
            .navigationTitle("To Do")
        }
    }
    
    //MARK: Functions
    func removeRows(at offsets: IndexSet) {
        
        Task {
            try await db!.transaction { core in
                
                //get the ID of the item to be deleted
                var idList = ""
                for offset in offsets {
                    idList += "\(todoItems.results[offset].id),"
                }
                
                //Remove the final comma
                print(idList)
                idList.removeLast()
                print(idList)
                
                //Delete the rows from the database
                try core.query("DELETE FROM TodoItem WHERE id IN (?)", idList)
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
