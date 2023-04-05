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
                    .onTapGesture {
                        Task {
                            try await db!.transaction { core in
                                //Chnage the status for this person to the opposite of its current value
                                try core.query("UPDATE TodoItem SET completed = (?) WHERE id = (?)", !currentItem.completed, currentItem.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("To Do")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
