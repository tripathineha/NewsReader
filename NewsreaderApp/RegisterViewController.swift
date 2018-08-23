//
//  RegisterViewController.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Validation methods
extension RegisterViewController{
    
    @IBAction func onRegisterButtonTapped(_ sender: UIButton) {
        
        guard var emailId = emailTextField.text,
            let password = passwordTextField.text,
            let repassword = rePasswordTextField.text,
            let username = usernameTextField.text
            else {
                createErrorAlert(title: Values.invalidInput.localised, message: Values.fields_empty.localised, hasCancelAction: false)
                return
        }
        
        guard password == repassword else {
            createErrorAlert(title: Values.password.localised, message: Values.passwords_dont_match.localised, hasCancelAction: false)
            return
        }
        
        guard isEmailValid(value: emailId) else {
            createErrorAlert(title: Values.alert.localised, message: Values.email_invalid.localised, hasCancelAction: false)
            return
        }
        
        guard isPasswordValid(password: password) else {
            createErrorAlert(title: Values.alert.localised, message: Values.password_invalid.localised, hasCancelAction: false)
            return
        }
        
        emailId = emailId.lowercased()
        let isEmailPresent = DataManager.sharedInstance.checkUser(emailId: emailId)
        guard isEmailPresent else {
            createErrorAlert(title: Values.alert.localised, message: Values.email_already_present.localised, hasCancelAction: false)
            return
        }
        let pass = String(password.hashValue)
        let valueDictionary : [String:Any] = [ UserEntity.email.rawValue:emailId,
                                UserEntity.name.rawValue:username,
                                UserEntity.password.rawValue:pass
                                ]
        
        DataManager.sharedInstance.registerUser(valueDictionary: valueDictionary)
        navigationController?.popViewController(animated: true)
       
    }
    
    // Validate Email
    private func isEmailValid(value:String?) -> Bool{
        let regularExpression = RegEx.email.rawValue
        if value != nil{
            return value!.range(of: regularExpression, options: .regularExpression, range: nil, locale: nil) != nil
        }
        return false
    }
    
    // Validate Password
    private func isPasswordValid(password:String?) -> Bool{
        if let password = password{
            let regularExpression = RegEx.password.rawValue
            let isMatch = password.range(of: regularExpression, options: .regularExpression, range: nil, locale: nil) != nil
            return isMatch
        }
        return false
    }
    
}

// MARK: - Custom methods
extension RegisterViewController {
    
    // Create custom Error Alert
    private func createErrorAlert(title: String?, message: String?, hasCancelAction: Bool)  {
        createAlert(title: title, message: message, hasCancelAction: hasCancelAction)
        passwordTextField.text = ""
        rePasswordTextField.text = ""
        return
    }
}
