//
//  NewsTableViewDelegate.swift
//  NewsreaderApp
//
//  Created by Globallogic on 03/02/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class NewsTableViewDelegate : NSObject,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
