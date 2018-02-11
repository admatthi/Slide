//
//  WelcomeViewController.swift
//  SlideApp
//
//  Created by Alek Matthiessen on 2/9/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit

var testtexts = [String]()

var tapped = Bool()

class WelcomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tapstartsending: UIButton!
    @IBAction func tapStartSending(_ sender: Any) {
        
        self.performSegue(withIdentifier: "WelcomeToHome", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.reloadData()
        tapstartsending.alpha = 0
        
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
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if testtexts.count > 0 {
            
            return testtexts.count
            
        } else {
            
            return 1
        }
        
        
        //        return 5
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Texts", for: indexPath) as! AppTextsCollectionViewCell
        
        if testtexts.count > indexPath.row {
            
            cell.textlabel.text = testtexts[indexPath.row]
            
            cell.image.image = UIImage(named: "GreyChatBubble")
            
        } else {
            
            cell.textlabel.text = ""
            cell.image.image = UIImage(named: "GreyChatBubble")
            
        }
        
        
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        textDocumentProxy.insertText(texts[responseids[indexPath.row]]!)
        
        ref?.child("SentMessage").child(uid).childByAutoId().updateChildValues(["Text" : [responseids[indexPath.row]]])
        
        ref?.child("Messages").child("Favorites").child(uid).childByAutoId().updateChildValues(["Text" : texts[responseids[indexPath.row]]])

        let cell = collectionView.cellForItem(at: indexPath) as! AppTextsCollectionViewCell
        
        cell.image.image = UIImage(named: "PurpleChatBubble")
        
        tapstartsending.alpha = 1
        
    }
    
}
