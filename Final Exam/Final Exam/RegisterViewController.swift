//
//  RegisterViewController.swift
//  Final Exam
//
//  Created by english on 2024-04-25.
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
            print("Sign In button clicked.")
            if emailText.text != "" && passwordText.text != "" {
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text! ){
                    ( authData, error) in
                    if error != nil {
                        self.makeAlert(titleInput: "Firebase Error", messageInput: error?.localizedDescription ?? "Something went wrong!")
                    }else {
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }
            }else{
                makeAlert(titleInput: "Error", messageInput: "Email/Password is missing!")
            }
        }
    
    func makeAlert(titleInput: String, messageInput: String) {
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
}
