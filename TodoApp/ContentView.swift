//
//  ContentView.swift
//  TodoList
//
//  Created by Joanne Wong on 11/19/23.
//
import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage = TodoStorage()
    @State private var showPlusSheet = false
    @State private var showComplete = false
    @State private var editSheet = false
    @State private var swipedRowIndex: Int? = nil

    var body: some View {
        NavigationView{
            List {
                ForEach(removeDuplicates().indices, id: \.self) { index in
                    HStack {
                        Circle()
                            .foregroundStyle(.clear)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: storage.storageItem[index].tapped ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(storage.storageItem[index].tapped ? .blue : .gray)
                            )
                            .contentShape(Circle()) // Set content shape to Circle
                            .onTapGesture {
                                storage.storageItem[index].tapped.toggle()
                                moveTappedItemToTop(index: index)
                            }
                        VStack {
                            NavigationLink {
                                ListView(selectedProjectName: storage.storageItem[index].projectName)
                            } label: {
                                Text(storage.storageItem[index].projectName)
                                    .font(.headline)
                                    .foregroundStyle(storage.storageItem[index].tapped ? .gray : .black)
                                    .strikethrough(storage.storageItem[index].tapped)
                            }
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            removeItem(at: index)
                            
                        } label: {
                            Text("Delete")
                                .foregroundStyle(.white)
                        }
                        Button {
                            swipedRowIndex = index
                        } label: {
                            Text("Edit")
                        }
                    }
                }
                .sheet(isPresented: Binding<Bool>(
                    get: { swipedRowIndex != nil },
                    set: { if !$0 { swipedRowIndex = nil } }
                )) {
                    // Pass the item at the swiped index into the sheet
                    if let index = swipedRowIndex {
                        EditProjectName(storage: storage, selectedIndex: index, selectedProjectName: storage.storageItem[index].projectName)
                    }
                }
                Button("Show Completed Items") {
                    showComplete.toggle()
                }
                if showComplete {
                    ForEach(storage.storageItem.filter{$0.tapped}) {
                        Text($0.projectName)
                    }
                }
                    Text("Completed Tasks: \(storage.storageItem.filter { $0.tapped }.count)")
                        .font(.headline)
                        .foregroundColor(.gray)
            }
            .navigationTitle("Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.yellow, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button(action:{
                        showPlusSheet = true
                    }){
                        Label("Add Task", systemImage: "plus")
                            .font(.headline)
                    }
                }
            }
            .sheet(isPresented: $showPlusSheet) {
                AddTodo(storage: storage)
            }
        }
    }
    func removeRows(at offset: IndexSet) {
        storage.storageItem.remove(atOffsets: offset)
    }
    
    func moveTappedItemToTop(index: Int) {
        let item = storage.storageItem[index]
        
        if item.tapped {
            storage.storageItem.remove(at: index)
            storage.storageItem.append(item)
        } else {
            storage.storageItem.remove(at: index)
            storage.storageItem.insert(item, at: 0)
        }
    }
    func removeItem(at index: Int) {
        storage.storageItem.remove(at: index)
    }
    func removeDuplicates() -> [TodoItem] {
        var unique = [TodoItem]()
        self.storage.storageItem.forEach { item in
            if !unique.contains(where: {$0.projectName == item.projectName}) {
                unique.append(item)

            }
        }
        return unique
    }

}





#Preview {
    ContentView()
}
