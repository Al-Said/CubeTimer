//
//  SignUpPageViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 15.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpPageViewController: BaseOnboardViewController {

    @IBOutlet weak var signUpButton: CubeTimerButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }

    func setUI() {
        self.signUpButton.initUI(with: .dark)
        
        self.nameTextField.placeholder = "Name Surname"
        self.emailTextField.placeholder = "E-mail"
        self.passwordTextField.placeholder = "Password"
        self.confirmationTextField.placeholder = "Confirm Password"
        
        self.nameTextField.textContentType = .givenName
        self.emailTextField.textContentType = .emailAddress
        self.emailTextField.keyboardType = .emailAddress
        
        self.passwordTextField.keyboardType = .default
        self.confirmationTextField.keyboardType = .default
        self.passwordTextField.isSecureTextEntry = true
        self.confirmationTextField.isSecureTextEntry = true
        
        self.spinner.isHidden = true
    }
    
    func checkName() -> Bool {
        if let name = self.nameTextField.text {
            if !name.isEmpty && name.contains(" ") {
                return true
            }
            
            showErrorPopup(message: "Please enter Name and Surname")
            return false
        } else {
            return false
        }
    }
    
    func checkEmail() -> Bool {
        if let mail = self.emailTextField.text {
            let valid = NSPredicate(format: "SELF MATCHES %@", self.emailRegex).evaluate(with: mail)
            if valid {
               return true
            }
            
            showErrorPopup(message: "Please enter an valid e mail")
            return false
            
        } else {
            return false
        }

    }
    
    func checkPasswords() -> Bool {
        if let pass = self.passwordTextField.text {
            if let conf = self.confirmationTextField.text {
                let valid = NSPredicate(format: "SELF MATCHES %@", self.passwordRegex).evaluate(with: pass)
                
                if !valid {
                    showErrorPopup(message: "Your password should consist at least 1 uppercase, 1 lowercase and 1 digit with at least 6 character, at most 15 character")
                    return false
                }
                
                if pass != conf {
                    showErrorPopup(message: "Passwords do not match. Please re-enter your passwords")
                    return false
                }
                
                return true
                
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        if !(checkName() && checkEmail() && checkPasswords()) {
            return
        }
        let name  = self.nameTextField.text!.split(separator: " ")
        let email = self.emailTextField.text!
        let pass  = self.passwordTextField.text!
        let user = User(name: String(name[0]), surname: String(name[1]), email: email, password: pass)
        
        print(user)
        
        Auth.auth().createUser(withEmail: user.email
        , password: user.password) { (usr, err) in
            
            if err == nil && usr != nil {
                self.spinner.stopAnimating()
                print("User created")
                self.directMainPage()
            } else {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                if err!.localizedDescription == "The email address is already in use by another account." {
                    self.showErrorPopup(message: "This email address is already exist")
                } else {
                    self.showErrorPopup(message: "An error has occured")
                }
            }
        }
    }
    
    
}
