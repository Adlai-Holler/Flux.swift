//
//  ManagedObjectContextChange.swift
//  TodoMVC
//
//  Created by Adlai Holler on 2/6/16.
//  Copyright © 2016 Adlai Holler. All rights reserved.
//

import CoreData

/// This is basically the userInfo of an NSManagedObjectContextDidSaveNotification or
/// NSManagedObjectContextObjectsDidChangeNotification.
struct ManagedObjectContextChange {
    var insertedObjects: Set<NSManagedObject>
    var updatedObjects: Set<NSManagedObject>
    var deletedObjects: Set<NSManagedObject>

    init(notification: NSNotification) {
		let userInfo = notification.userInfo
        updatedObjects = userInfo?[NSUpdatedObjectsKey] as! Set<NSManagedObject>? ?? []
        deletedObjects = userInfo?[NSDeletedObjectsKey] as! Set<NSManagedObject>? ?? []
        insertedObjects = userInfo?[NSInsertedObjectsKey] as! Set<NSManagedObject>? ?? []
    }

    init() {
        insertedObjects = []
        deletedObjects = []
        updatedObjects = []
    }
}
