//
//  AddInsideTodo.swift
//  TodoApp
//
//  Created by Joanne Wong on 11/27/23.
//

import SwiftUI

struct AddInsideTodo: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage = TodoStorage()
    @State private var projectTitle = ""
    @State private var todoName = ""
    @State private var todoDescription = ""
    @State private var showMenu = false
    
    var selectedIndex: Int?
    
    var selectedProjectName: String
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Project Name", text: $projectTitle)
                TextField("New Todo Name", text: $todoName)
                TextField("Description", text: $todoDescription)
            }
            .onAppear {
                // Set the initial project title from the selectedProjectName
                projectTitle = selectedProjectName
            }
            .navigationTitle("Add Todo")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.yellow, for: .navigationBar)
            .toolbar() {
                Button("Save") {
                    let newTextField = TodoItem(id: UUID(), projectName: projectTitle, name: todoName, description: todoDescription)
                    storage.storageItem.append(newTextField)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddInsideTodo(selectedProjectName: "Hello")
}
