//
//  TasksList.swift
//  RealmTaskApp
//
//  Created by l.vladislava on 23/02/2021.
//

import Foundation
import RealmSwift

class TasksList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
    
    
}
