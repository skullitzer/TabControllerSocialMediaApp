//
//  ViewController.swift
//  Final Exam
//
//  Created by english on 2024-04-25.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("Login Button Clicked!")
                if emailText.text != "" && passwordText.text != ""{
                    Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!){
                        ( authData, error) in
                        if error != nil {
                            self.makeAlert(titleInput: "Firebase Error", messageInput: error?.localizedDescription ?? "Something went wrong!")
                        }else{
                            self.performSegue(withIdentifier: "LoginToTab2", sender: nil)
                        }
                    }
                }else{
                    makeAlert(titleInput: "Error", messageInput: "Email/Password Missing!")
                }
    }
    
    // Alert box
    func makeAlert(titleInput: String, messageInput: String) {
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
}

