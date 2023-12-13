//
//  TodoItem.swift
//  TodoList
//
//  Created by Joanne Wong on 11/21/23.
//

import Foundation

struct TodoItem: Identifiable, Codable, Hashable {
    var id: UUID
    var projectName: String
    var name: String
    var description: String
    var tapped = false
    
}

