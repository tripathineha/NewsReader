//
//  Extensions.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIImageView Extension
//Class extension for UIImageView image download
extension UIImageView {
    
    /// Method for downloading image from URL for the imageView
    ///
    /// - Parameter url: URL of the image
    public func imageFromURL(url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if error != nil { return }
            DispatchQueue.main.async(execute: { () in
                if let data = data {
                    let image = UIImage(data: data)
                    self.image = image
                }
                else {
                    self.image = UIImage(named : "defaultPhoto")
                }
            })
        }).resume()
    }
}
// MARK: - UIViewController Extension 
extension UIViewController {
    /// method to create an alert whenever any error occurs
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: Message of the alert
    ///   - hasCancelAction: true if the alert has a cancel action along with ok action, otherwise false
    /// - Returns: alert with the above properties
    func createAlert(title: String? , message: String?, hasCancelAction : Bool){
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        if hasCancelAction {
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            errorAlert.addAction(cancelAction)
        }
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func saveDefaultUser(emailId: String?, password: String?){
        let defaults = UserDefaults.standard
        defaults.set(emailId, forKey: "emailId")
        defaults.set(password, forKey: "password")
    }
    
    func getDefaultUser() -> (String?,String?){
        let defaults = UserDefaults.standard
        let emailId = defaults.object(forKey: "emailId") as? String
        let password = defaults.object(forKey: "password") as? String
        return (emailId,password)
    }
}

//MARK: - UIView Extension
extension UIView {
    
    func resizeToFitSubviews(){
        
        let subViewsRect = subviews.reduce(CGRect.zero) {
            $0.union($1.frame)
        }
        
        let fix = subViewsRect.origin
        
        subviews.forEach{
            $0.frame.offsetBy(dx: -fix.x, dy: -fix.y)
        }
        
        frame.offsetBy(dx: fix.x, dy: fix.x)
        frame.size = subViewsRect.size
    }
}

//MARK: - String Extension

extension String {
    
    func localized() -> String{
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: "", comment: "")
    }
    
}
