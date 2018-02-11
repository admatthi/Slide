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
    
    @IBOutlet weak var errorlabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func tapNext(_ sender: Any) {
        
        signinwithemail()
    }
    
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
                                        
                    self.performSegue(withIdentifier: "PasswordToWelcome", sender: self)
                    
                    
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
                    self.errorlabel.alpha = 1
                    self.errorlabel.text = error.localizedDescription

                    
                    return
                    
                } else {
                    
                    uid = (Auth.auth().currentUser?.uid)!
                    
                    UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "uid")
                    
            ref?.child("Users").child(uid).updateChildValues(["Age" : myage, "FirstName" : myfirstname])
                    
                self.performSegue(withIdentifier: "PasswordToWelcome", sender: self)
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
        errorlabel.alpha = 0
        // Do any additional setup after loading the view.
        
        appendtestexts()
    }
    
    func appendtestexts() {
        
        testtexts.removeAll()
        
            testtexts.append("There are 16 year olds in the olympics and I still push on pull doors.")
        testtexts.append("I came. I saw. I made it awkward.")
        testtexts.append("I need cake because Monday.")
            testtexts.append("To manifest it, you must believe in its inevitability.")
        testtexts.append("That’s usually how I see things.")
            testtexts.append("Sometimes I just feel dead as a doornail")
            testtexts.append("I decide my vibe.")
            testtexts.append("I hear you in my music.")
            testtexts.append("Lost at sea? Are you shore?")
            testtexts.append("Stress doesn't really go with my outfit.")
            testtexts.append("Get your fat pants ready.")
            testtexts.append("Coffee helps.")
            testtexts.append("Never put the key to your happiness in somebody else's pocket.")
            testtexts.append("Many have an image of me. Few get the picture.")
            testtexts.append("BRB while I go be awesome.")
            testtexts.append("Soul on fleek rn.")


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
