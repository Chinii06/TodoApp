//
//  EditProjectName.swift
//  TodoList
//
//  Created by Joanne Wong on 11/27/23.
//

import SwiftUI

struct EditProjectName: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage = TodoStorage()
    @State private var projectTitle = ""
    @State private var todoName = ""
    @State private var todoDescription = ""
    
    
    var selectedIndex: Int?
    
    var selectedProjectName: String
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter your project Name", text: $projectTitle)
                
            }
            .onAppear {
                // Set the initial project title from the selectedProjectName
                projectTitle = selectedProjectName
            }
            .navigationTitle("Project Name")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.yellow, for: .navigationBar)
            .toolbar(){
                Button("Save") {
                    if let editTextField = selectedIndex {
                        storage.storageItem[editTextField].projectName = projectTitle
//                        dismiss()
                    }
                    dismiss()
                    
                }
                //                .onAppear {
                //                    if let existingTextField = selectedIndex {
                //                        projectTitle = storage.storageItem[existingTextField].projectName
                //
                //                    }
                //                }
            }
        }
    }
}



#Preview {
    EditProjectName(selectedProjectName: "Project Names")
}
