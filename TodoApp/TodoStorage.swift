//
//  Todo.swift
//  TodoList
//
//  Created by Joanne Wong on 11/21/23.
//

import Foundation

class TodoStorage: ObservableObject {
    @Published var storageItem : [TodoItem] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(storageItem) {
                UserDefaults.standard.set(encoded, forKey: "Item")
            }
        }
    }
    init() {
        if let saveItem = UserDefaults.standard.data(forKey: "Item") {
            if let decodedItem = try? JSONDecoder().decode([TodoItem].self, from: saveItem) {
                storageItem = decodedItem
            }
        } else {
            storageItem = []
        }
    }
}


