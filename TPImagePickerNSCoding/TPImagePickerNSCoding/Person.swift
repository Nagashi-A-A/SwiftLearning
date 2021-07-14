//
//  Person.swift
//  Project10
//
//  Created by Anton Yaroshchuk on 23.06.2021.
//

import UIKit

class Person: NSObject, Codable {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.image = image
        self.name = name
    }

}
