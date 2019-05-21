//
//  LoginPageViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 15.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginPageViewController: BaseOnboardViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: CubeTimerButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.setUI()
    }
    
    func setUI() {
        self.loginButton.initUI(with: .dark)
        
        self.emailTextField.placeholder = "E-mail"
        self.passwordTextField.placeholder = "Password"
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.textContentType = .emailAddress
        self.emailTextField.keyboardType = .emailAddress
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.textContentType = .password
        self.passwordTextField.isSecureTextEntry = true
        
        self.spinner.isHidden = true
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if err == nil && user != nil {
                print("successful!!")
                self.directMainPage()
            } else {
                self.showErrorPopup(message: "An error has occured!")
                print(err!.localizedDescription)
            }
            self.spinner.stopAnimating()
        }
    }

}

extension LoginPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
