//
//  Item.swift
//  Todo List App
//
//  Created by Arpan Bhowmik on 10/2/23.
//

import Foundation

class Item: Codable {
    var title: String
    var isChecked = false
    
    init(title: String) {
        self.title = title
    }
}
