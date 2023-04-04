//
//  ListVIew.swift
//  ToDoList
//
//  Created by Justin Hui on 4/4/2023.
//

import SwiftUI

struct ListVIew: View {
    
    //MARK: Computed Properties
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                HStack{
                    
                    TextField("Enter a to-do item", text: Binding.constant(""))
                    
                    Button(action: {
                        
                    }, label: {
                        Text("ADD")
                            .font(.caption)
                    })
                }
                .padding()
                
                List {
                    HStack{
                        Image(systemName: "circle")
                            .foregroundColor(.blue)
                        Text("Study for Physics test")
                    }
                    
                    HStack{
                        Image(systemName: "circle")
                            .foregroundColor(.blue)
                        Text("Finish Math Homework")
                    }
                    
                    HStack{
                        Image(systemName: "circle")
                            .foregroundColor(.blue)
                        Text("Go to the gym")
                    }
                }
            }
            .navigationTitle("To Do")
        }
    }
}

struct ListVIew_Previews: PreviewProvider {
    static var previews: some View {
        ListVIew()
    }
}
