//
//  AddTodo.swift
//  TodoList
//
//  Created by Joanne Wong on 11/19/23.
//

import SwiftUI

struct AddTodo: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage = TodoStorage()
    @State private var projectTitle = ""
    @State private var todoName = ""
    @State private var todoDescription = ""
    @State private var showMenu = false
    
    var selectedIndex: Int?
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    HStack {
                        TextField("Project Name", text: $projectTitle)
                        Menu {
                            ForEach(storage.storageItem.indices, id: \.self) { option in
                                Button(storage.storageItem[option].projectName) {
                                    self.projectTitle = storage.storageItem[option].projectName
                                    self.showMenu = false
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                }
                TextField("New Todo Name", text: $todoName)
                TextField("Description", text: $todoDescription)
            }
            .navigationTitle("Add Todo")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.yellow, for: .navigationBar)
            .toolbar(){
                Button("Save") {
                    if let existingTextField = selectedIndex {
                        storage.storageItem[existingTextField].projectName = projectTitle
                        storage.storageItem[existingTextField].name = todoName
                        storage.storageItem[existingTextField].description = todoDescription
                        dismiss()
                    } else {
                        let newTextField = TodoItem(id: UUID(), projectName: projectTitle, name: todoName, description: todoDescription)
                        storage.storageItem.append(newTextField)
                        dismiss()
                    }
                }
                .disabled(todoName.isEmpty || todoDescription.isEmpty || projectTitle.isEmpty)
                
                .onAppear {
                    if let existingTextField = selectedIndex {
                        projectTitle = storage.storageItem[existingTextField].projectName
                        todoName = storage.storageItem[existingTextField].name
                        todoDescription = storage.storageItem[existingTextField].description
                        
                    }
                }
            }
        }
    }
}

#Preview {
    AddTodo()
    
}
