//
//  ListItemsView.swift
//  ToDoList
//
//  Created by Justin Hui on 13/4/2023.
//

import Blackbird
import SwiftUI

struct ListItemsView: View {
    
    //MARK: Stored Proerties
    
    //Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    //The list of items to be completed
    @BlackbirdLiveModels ({ db in
        try await TodoItem.read(from: db, sqlWhere: "description LIKE ?", "%\(searchText)%")
    }) var todoItems
    
    //MARK: Computed Properties
    var body: some View {
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

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemsView()
    }
}
