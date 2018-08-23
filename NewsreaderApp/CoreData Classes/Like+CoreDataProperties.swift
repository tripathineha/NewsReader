//
//  Like+CoreDataProperties.swift
//  NewsreaderApp
//
//  Created by Globallogic on 03/02/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//
//

import Foundation
import CoreData


extension Like {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Like> {
        return NSFetchRequest<Like>(entityName: "Like")
    }

    @NSManaged public var like: Int16
    @NSManaged public var newsLink: String?
    @NSManaged public var comments: NSSet?
    @NSManaged public var likedBy: NSSet?

}

// MARK: Generated accessors for comments
extension Like {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

// MARK: Generated accessors for likedBy
extension Like {

    @objc(addLikedByObject:)
    @NSManaged public func addToLikedBy(_ value: User)

    @objc(removeLikedByObject:)
    @NSManaged public func removeFromLikedBy(_ value: User)

    @objc(addLikedBy:)
    @NSManaged public func addToLikedBy(_ values: NSSet)

    @objc(removeLikedBy:)
    @NSManaged public func removeFromLikedBy(_ values: NSSet)

}
