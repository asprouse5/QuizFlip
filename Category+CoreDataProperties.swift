//
//  Category+CoreDataProperties.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var parent: String?
    @NSManaged public var questions: NSObject?

}
