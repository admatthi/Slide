//
//  PasswordViewController.swift
//  Slide MessagesExtension
//
//  Created by Alek Matthiessen on 1/22/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

var uid = String()

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    func signinwithemail() {
        
        if textField.text != "" {
            
            var password = textField.text!
            
            var email = "\(FirstName)@gmail.com"
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    
                    self.createaccountwithemail()
                    
                    return
                    
                } else {
                    
                    uid = (Auth.auth().currentUser?.uid)!
                                        
                    self.performSegue(withIdentifier: "LoginToSlide", sender: self)
                    
                    
                }
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func createaccountwithemail() {
        
        if textField.text != "" {
            
            var password = textField.text!
            var email = "\(FirstName)@gmail.com"

            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)

                    
                    return
                    
                } else {
                    
                    uid = (Auth.auth().currentUser?.uid)!
                    
            
                self.performSegue(withIdentifier: "LoginToSlide", sender: self)
                }
            }
            
            
        } else {
            
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        textField.delegate = self
        textField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
