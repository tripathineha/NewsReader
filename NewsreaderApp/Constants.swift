//
//  Constants.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//
import UIKit

enum JsonKeys : String {
    case articles = "articles"
    case title = "title"
    case newsDescription = "description"
    case url = "url"
    case imageUrl = "urlToImage"
    case author = "author"
    case publishedAt = "publishedAt"
    case source = "source"
    case sourceId = "id"
    case sourceName = "name"
    case apiKey = "apiKey"
    case sourcesKey = "category"
    case country = "country"
}

let CategoryList = [
    "Top News",
    "Business",
    "Entertainment",
    "Health",
    "Science",
    "Sports",
    "Technology",
    "Logout"
]

enum Source : String {
    case topnews = ""
    case business = "business"
    case entertainment = "entertainment"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}

enum NewsCategory : String {
    case topnews = "Top News"
    case business = "Business"
    case entertainment = "Entertainment"
    case health = "Health"
    case science = "Science"
    case sports = "Sports"
    case technology = "Technology"
}

enum APIData : String {
    case APIKey = "6f1f9812f9994150b521dd734c4662b2"
    case APISource = "https://newsapi.org/v2/top-headlines"
    case APICountry = "in"
}

enum Values : String {
    
    case error = "error"
    case invalidData = "invalid_data_received"
    case invalidInput = "invalid_inputs"
    case fields_empty = "fields_empty"
    case username_password_wrong = "username_password_wrong"
    case password = "password"
    case passwords_dont_match = "passwords_dont_match"
    case email = "email"
    case email_invalid = "email_invalid"
    case password_invalid = "password_invalid"
    case alert = "alert"
    case email_already_present = "email_already_present"
    case invalid_indexpath = "invalid_indexpath"
    case source_not_found = "source_not_found"
    case defaultValue = "defaultValue"
    case cell_not_initialised = "cell_not_initialised"
    case comment = "comment"
    case comment_empty = "comment_empty"
    case link_couldnt_be_loaded = "link_couldnt_be_loaded"
    case likes = "likes"
    case unlike = "unlike"
    case like = "like"
    case unknown = "unknown"
    case logout = "logout"
    case improper_url = "improper_url"
    
    var localised : String {
        return self.rawValue.localized()
    }
}

enum RegEx : String {
    case email = "^[A-Z0-9a-z_.]+@[A-Za-z]+\\.[A-Za-z]{2,3}$"
    case password = "^[^\\s]{8,40}$"
}

enum Theme : CGFloat {
    case red = 255.0
    case green = 250.0
    case blue = 240.0
}

enum GradientTo: CGFloat {
    case red = 0.0
    case blue = 145.0
    case green = 147.0
}

enum GradientFrom : CGFloat {
    case red = 64.0
    case blue = 224.0
    case green = 208.0
}

enum Entity : String {
    case user = "User"
    case comment = "Comment"
    case like = "Like"
}

enum UserEntity : String {
    case email = "emailId"
    case name = "name"
    case password = "password"
}

enum CommentEntity : String {
    case comment = "comment"
    case commentedAt = "commentedAt"
    case commentOn = "commentOn"
    case commentedBy = "commentedBy"
}

enum LikeEntity : String {
    case newsLink = "newsLink"
    case like = "like"
    case likedBy = "likedBy"
    case comments = "comments"
}
