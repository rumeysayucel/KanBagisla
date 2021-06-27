//
//  LoginViewController.swift
//  KanBagisla
//
//  Created by Rumeysa Yücel on 27.02.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var showingAlert = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    self.showAlert()
                } else {
                    self.performSegue(withIdentifier: "LoginToHome", sender: self)
                }
            }
        }
    }
    
    func showAlert() {
        
        showingAlert = true
        
        let showingAlert = UIAlertController(title: "Hata!", message:
                "Lütfen e-mailinizi ve şifrenizi kontrol ediniz.", preferredStyle: .alert)
            showingAlert.addAction(UIAlertAction(title: "Kapat", style: .default))

            self.present(showingAlert, animated: true, completion: nil)
    }

    

}
