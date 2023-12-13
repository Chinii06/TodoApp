//
//  ListView.swift
//  TodoList
//
//  Created by Joanne Wong on 11/21/23.
import SwiftUI

struct ListView: View {
    @ObservedObject var storage = TodoStorage()
    @State private var showSheet = false
    @State private var showCompleteTodo = false
    @State private var insideShowSheet = false
    
    @State private var swipedRowIndex: Int? = nil
    
    var selectedProjectName: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(storage.storageItem.indices, id: \.self ) { index in
                    if selectedProjectName == storage.storageItem[index].projectName{
                        HStack {
                            Circle()
                                .foregroundColor(.clear)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: storage.storageItem[index].tapped ?
                                          "checkmark.circle.fill" : "circle")
                                    .foregroundColor(storage.storageItem[index].tapped ? .blue : .gray)
                                )
                                .onTapGesture {
                                    storage.storageItem[index].tapped.toggle()
                                    moveTappedItemToTop(index: index)
                                }
                            VStack {
                                Text(storage.storageItem[index].name)
                                    .foregroundStyle(storage.storageItem[index].tapped ? .gray : .black)
                                    .strikethrough(storage.storageItem[index].tapped)
                                    .font(.headline)
                                    .bold()
                                
                                Text(storage.storageItem[index].description)
                                    .foregroundStyle(storage.storageItem[index].tapped ? .gray : .black)
                                    .strikethrough(storage.storageItem[index].tapped)
                                    .font(.caption)
                            }
                            .sheet(isPresented: $showSheet) {
                                AddTodo(storage: storage, selectedIndex: index)
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
                }
                .sheet(isPresented: Binding<Bool>(
                    get: { swipedRowIndex != nil },
                    set: { if !$0 { swipedRowIndex = nil } }
                )) {
                    // Pass the item at the swiped index into the sheet
                    if let index = swipedRowIndex {
                        AddTodo(storage: storage, selectedIndex: index)
                    }
                }
                Button("Show Complete Task") {
                    showCompleteTodo.toggle()
                }
                Text("Completed Tasks: \(storage.storageItem.filter { $0.tapped }.count)")
                    .font(.headline)
                    .foregroundColor(.gray)
        
                if showCompleteTodo {
                    ForEach(storage.storageItem.filter{$0.tapped}) {
                        Text($0.name)
                    }
                }
            }
        }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    ForEach(storage.storageItem.indices, id: \.self) { index in
                        if selectedProjectName == storage.storageItem[index].projectName {
                            Button {
                                insideShowSheet = true
                            } label: {
                                ZStack{
                                    Circle()
                                        .frame(width: 800, height: 50)
                                    Image(systemName: "plus")
                                        .buttonStyle(.borderedProminent)
                                        .tint(.white)
                                }
                            }
                            .sheet(isPresented: $insideShowSheet) {
                                AddInsideTodo(storage: storage, selectedIndex: index, selectedProjectName: storage.storageItem[index].projectName)
                            }
                        }
                    }
                    //                }
                    //            .toolbar {
                    //                ToolbarItem(placement: .navigationBarTrailing) {
                    //                    EditButton() // This adds the Edit button for enabling deletion
                    //                }
                    //            }
                }
            }
        .navigationTitle("\(selectedProjectName)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.yellow, for: .navigationBar)
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
}
    

#Preview {
    ListView(selectedProjectName: "Sample Project Name")
}
