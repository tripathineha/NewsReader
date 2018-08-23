//
//  Comment+CoreDataProperties.swift
//  NewsreaderApp
//
//  Created by Globallogic on 03/02/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var comment: String?
    @NSManaged public var commentedAt: NSDate?
    @NSManaged public var commentedBy: User?
    @NSManaged public var commentOn: Like?

}
