//
//  NewsObject.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation

class NewsObject : NSObject {
    var title : String
    var newsDescription : String
    var url : String
    var imageUrl : String?
    var author : String?
    var publishedAt :  String
    
    init(title : String, description : String, url : String, imageUrl : String?, author : String?, publishedAt :  String) {
        self.title = title
        self.newsDescription = description
        self.url = url
        self.imageUrl = imageUrl
        self.author = author
        self.publishedAt = publishedAt
    }
    
    convenience init?(json : Dictionary<String, Any>) {
        
        let author = json[ JsonKeys.author.rawValue] as? String
        let imageUrl  = json[ JsonKeys.imageUrl.rawValue] as? String
        
        guard let title = json[ JsonKeys.title.rawValue] as? String,
            let url = json[ JsonKeys.url.rawValue] as? String,
            let description = json[ JsonKeys.newsDescription.rawValue] as? String,
            let publishedAt = json[ JsonKeys.publishedAt.rawValue] as? String
            else{
                return nil
        }
        self.init(title : title, description : description, url : url, imageUrl : imageUrl, author : author, publishedAt :  publishedAt)
    }
}

