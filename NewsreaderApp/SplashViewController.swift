//
//  SplashViewController.swift
//  NewsreaderApp
//
//  Created by Neha Tripathi on 01/02/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
   
    private let HomeSegue = "Go To Home"
    private let LoginSegue = "Go To Login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradient : CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor(red:GradientFrom.red.rawValue/255.0,green:GradientFrom.green.rawValue/255.0,blue:GradientFrom.blue.rawValue/255.0,alpha:1).cgColor, UIColor(red:GradientTo.red.rawValue/255.0,green:GradientTo.green.rawValue/255.0,blue:GradientTo.blue.rawValue/255.0,alpha:1).cgColor]
        gradient.locations = [0.0,1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.view.frame
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Delay the navigation for time interval
        DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
            self.checkUserDefaults()
        })
    }

}

extension SplashViewController {
    
    // Check the user defaults for remembered user
    private func checkUserDefaults(){
        let user : (emailId:String?,password:String?) = self.getDefaultUser()
        
        if let emailId = user.emailId,
            let password = user.password,
            DataManager.sharedInstance.login(emailId : emailId, password : password) == true {
            
            self.performSegue(withIdentifier: HomeSegue, sender: self)
            
        } else {
            self.performSegue(withIdentifier: LoginSegue, sender: self)
        }
    }
}

