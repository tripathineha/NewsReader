//
//  DataManager.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation
import CoreData

private let manager = DataManager()

class DataManager {
    
    var user : User?
    
    fileprivate init(){
        
    }
    
    class var sharedInstance : DataManager {
        return manager
    }
    
    lazy var persistentContainer : NSPersistentContainer = {
        
        var container = NSPersistentContainer(name: "NewsreaderApp")
        
        let description = container.persistentStoreDescriptions[0]
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error : \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        let managedContext = self.persistentContainer.newBackgroundContext()
        return managedContext
    }()
    
    func saveContext(){
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

// MARK: - Register and Login User
extension DataManager {
    
    func registerUser(valueDictionary : [String:Any])  {
        if let user = NSEntityDescription.insertNewObject(forEntityName: Entity.user.rawValue , into: managedObjectContext) as? User {
            print(valueDictionary)
            user.setValuesForKeys(valueDictionary)
            saveContext()
        } else {
            print("User not created!")
        }
    }
    
    func checkUser(emailId : String) -> Bool{
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "\(UserEntity.email.rawValue) == %@", emailId )
        fetchRequest.predicate = predicate
        var users = [User]()
        do{
            users = try managedObjectContext.fetch(fetchRequest)
            
        }catch {
            let fetchError = error as Error
            print ("Error is : \(fetchError)")
        }
        
        return users.count == 0
    }
    
    func login(emailId : String, password : String) -> Bool{
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        let idPredicate = NSPredicate(format: "\(UserEntity.email.rawValue) == %@", emailId )
        
        let encodedPassword = String(password.hashValue)
        print(encodedPassword)
        
        fetchRequest.predicate = idPredicate
        
        var users = [User]()
        do{
            users = try managedObjectContext.fetch(fetchRequest)
            
        }catch {
            let fetchError = error as Error
            print ("Error is : \(fetchError)")
            return false
        }

        if users.count != 0 ,
            let user = users.first,
            let userPassword  = user.password,
            userPassword == password {
            self.user = user
            return true
        }
    
        return false
    }
}

//MARK: - Comment Entity
extension DataManager {
    
    func deleteComment(object : NSManagedObject){
        managedObjectContext.delete(object)
        saveContext()
    }
    
    func saveComment(valueDictionary : [String:Any]){
        if let comment = NSEntityDescription.insertNewObject(forEntityName: Entity.comment.rawValue , into: managedObjectContext) as? Comment {
            comment.setValuesForKeys(valueDictionary)
            saveContext()
        } else {
            print("Comment not created!")
        }
    }
}

//MARK:- Like Entity
extension DataManager {
    
    private func fetchLikes(newsLink : String) -> Like? {
        let fetchRequest : NSFetchRequest<Like> = Like.fetchRequest()
        let predicate = NSPredicate(format: "\(LikeEntity.newsLink.rawValue) == %@",newsLink )
        fetchRequest.predicate = predicate
        var like = [Like]()
        do{
            like = try managedObjectContext.fetch(fetchRequest)
            
        }catch {
            let fetchError = error as Error
            print ("Error is : \(fetchError)")
        }
        return like.first
    }
    
    func likeNews(liked: Bool, newsLink : String) -> Like{
        var like = fetchLikes(newsLink: newsLink)
        if let like = like {
            if !liked {
                return like
            }
            if let users = like.likedBy,
                let user = self.user{
                if users.contains(user) {
                    like.like = like.like - 1
                    like.removeFromLikedBy(user)
                } else {
                    like.like = like.like + 1
                    like.addToLikedBy(user)
                }
            }
        } else {
            like = NSEntityDescription.insertNewObject(forEntityName: Entity.like.rawValue, into: managedObjectContext) as? Like
            if let like = like,
                let user = self.user {
                if !liked {
                    like.like = 0
                    like.newsLink = newsLink
                } else {
                    like.addToLikedBy(user)
                    like.like = 1
                    like.newsLink = newsLink
                }
            }
        }
        saveContext()
        return like!
    }
    
    func getLike(like: Like?) -> Bool{
        if let user = user,
            let like = like,
            let likes = user.likes{
            return likes.contains(like)
        }
     return false
    }
}

