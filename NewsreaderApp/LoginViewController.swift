//
//  LoginViewController.swift
//  NewsreaderApp
//
//  Created by Globallogic on 30/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordTextField.text = ""
        emailTextField.text = ""
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        guard var emailId = emailTextField.text,
            var password = passwordTextField.text else {
                createAlert(title: Values.invalidData.localised, message: Values.fields_empty.localised, hasCancelAction: false)
                return
        }
        
        password = String(password.hashValue)
        emailId = emailId.lowercased()
        let isValidUser = DataManager.sharedInstance.login(emailId : emailId, password : password)
        
        if isValidUser {
            
            if rememberSwitch.isOn {
                 saveDefaultUser(emailId: emailId, password: password)
            }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
            navigationController?.pushViewController(viewController, animated: true)
            
        } else {
            createAlert(title: Values.invalidInput.localised, message: Values.username_password_wrong.localised, hasCancelAction: false)
            return
        }
    }
}

