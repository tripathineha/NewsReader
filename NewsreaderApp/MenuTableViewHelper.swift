//
//  MenuTableViewHelper.swift
//  NewsreaderApp
//
//  Created by Globallogic on 30/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Menu TableView Data Source
class MenuTableViewHelper : NSObject, UITableViewDataSource {
    private let reuseIdentifier = "CategoryCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.textLabel?.text = CategoryList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DataManager.sharedInstance.user?.name
    }
    
}


