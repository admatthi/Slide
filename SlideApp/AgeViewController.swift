//
//  AgeViewController.swift
//  SlideApp
//
//  Created by Alek Matthiessen on 2/9/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit

var ages = [String]()
var comingfromlogin = Bool()
var myage = Int()
var myfirstname = String()

class AgeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var agelabel: UILabel!
    @IBOutlet weak var tapgetstarted: UIButton!
    @IBOutlet weak var taplogin: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func tapLogin(_ sender: Any) {
        
        comingfromlogin = true

        self.performSegue(withIdentifier: "AgeToFirstName", sender: self)
        
    }
    @IBAction func tapGetStarted(_ sender: Any) {
        
        comingfromlogin = false

        self.performSegue(withIdentifier: "AgeToFirstName", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addagestopickerView()
        tapgetstarted.alpha = 0
        comingfromlogin = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addagestopickerView() {
        

        ages.append("13")
        ages.append("14")
        ages.append("15")
        ages.append("16")
        ages.append("17")
        ages.append("18")
        ages.append("19")
        ages.append("20")
        ages.append("21")
        ages.append("22")
        ages.append("23")
        ages.append("24")
        ages.append("25")
        ages.append("26")
        ages.append("27")
        ages.append("28")
        ages.append("29")
        ages.append("30")
        ages.append("31")
        ages.append("32")
        ages.append("33")
        ages.append("34")
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return ages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        agelabel.text = ages[row]
        myage = Int(ages[row])!
        agelabel.textColor = .black
        tapgetstarted.alpha = 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if ages.count > 0 {
            
            return ages[row]
            
        } else {
            
            0
        }
        
        return "0"
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
