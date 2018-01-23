
//
//  FirstnameViewController.swift
//  Slide MessagesExtension
//
//  Created by Alek Matthiessen on 1/22/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit

var FirstName = String()

class FirstnameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tapnext: UIButton!
    @IBAction func tapNext(_ sender: Any) {
        
        if textField.text != "" {
            
            FirstName = textField.text!
            
            self.performSegue(withIdentifier: "FirstNameToPassword", sender: self)
            
        } else {
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.characters.count > 2 {
            
            tapnext.setBackgroundImage(UIImage(named: "WhiteButton"), for: .normal)
            tapnext.isEnabled = true
        } else {
            
            tapnext.setBackgroundImage(UIImage(named: "PurpleButtonReadyToPressNot"), for: .normal)
            tapnext.isEnabled = false
        }
        
        return true
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
