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
                
               
                .searchable(text: $searchText)
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
