//
//  User+CoreDataProperties.swift
//  NewsreaderApp
//
//  Created by Globallogic on 02/02/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var emailId: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var commented: NSSet?
    @NSManaged public var likes: NSSet?

}

// MARK: Generated accessors for commented
extension User {

    @objc(addCommentedObject:)
    @NSManaged public func addToCommented(_ value: Comment)

    @objc(removeCommentedObject:)
    @NSManaged public func removeFromCommented(_ value: Comment)

    @objc(addCommented:)
    @NSManaged public func addToCommented(_ values: NSSet)

    @objc(removeCommented:)
    @NSManaged public func removeFromCommented(_ values: NSSet)

}

// MARK: Generated accessors for likes
extension User {

    @objc(addLikesObject:)
    @NSManaged public func addToLikes(_ value: Like)

    @objc(removeLikesObject:)
    @NSManaged public func removeFromLikes(_ value: Like)

    @objc(addLikes:)
    @NSManaged public func addToLikes(_ values: NSSet)

    @objc(removeLikes:)
    @NSManaged public func removeFromLikes(_ values: NSSet)

}
