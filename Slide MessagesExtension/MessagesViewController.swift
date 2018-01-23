//
//  MessagesViewController.swift
//  Slide MessagesExtension
//
//  Created by Alek Matthiessen on 1/21/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit
import Messages
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

var texts = [String:String]()
var responseids = [String]()

var ref: DatabaseReference?

var feeling = String()


class MessagesViewController: MSMessagesAppViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tapadore: UIButton!
    @IBOutlet weak var taphappy: UIButton!
    @IBOutlet weak var tapopeners: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tapunhappy: UIButton!
    @IBOutlet weak var tapmovies: UIButton!
    
    @IBAction func tapMovies(_ sender: Any) {
        
        tappedfavorites()
        feeling = "Favorites"
        
        queryforfeelings()
    }
    var gridLayout: TextsFlowLayout = TextsFlowLayout(numberOfColumns: 3)

    @IBOutlet weak var loadingBackground: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func tapHappy(_ sender: Any) {
        
        tappedpositive()
        feeling = "Positive"
        
        queryforfeelings()
        
    }
    
    @IBAction func tapAdore(_ sender: Any) {
        
        tappedminus()
        feeling = "Minus"
        
        queryforfeelings()
        
        
    }
    @IBAction func tapOpeners(_ sender: Any) {
        
        tappedquestions()
        feeling = "Questions"
        
        queryforfeelings()
        
    }
    
    @IBAction func tapUnhappy(_ sender: Any) {
        
        tappedresponses()
        feeling = "Answers"
        
        queryforfeelings()
        
    }
    
    func startloading() {
        
        loadingBackground.alpha = 1
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }
    func hideloading() {
        
        loadingBackground.alpha = 0
        activityIndicator.alpha = 0
        activityIndicator.stopAnimating()
    }
    
    func queryforfeelingresponses() {
        
        var functioncounter = 0
        
        for each in responseids {
            
            ref?.child("Messages").child(feeling).child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var topic = value?["Text"] as? String {
                    
                    texts[each] = topic
                    
                }
                
                functioncounter += 1
                
                if functioncounter == responseids.count {
                    
                    self.collectionView.reloadData()
                    self.hideloading()
                }
            })
            
        }
    }
    
    func queryforresponseids(completed: @escaping ( () -> () )) {
        
        var functioncounter = 0
        
        ref?.child("Messages").child(feeling).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    responseids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        completed()
                        
                    }
                    
                    
                }
                
            }
            
        })
        
        
    }
    
    func queryforfeelings() {
        
        responseids.removeAll()
        texts.removeAll()
        
        startloading()
        queryforresponseids { () -> () in
            
            self.queryforfeelingresponses()
            
        }
    }
    
    func tappedfavorites() {
        
        tapmovies.setBackgroundImage(UIImage(named: "FavoritesTapped"), for: .normal)
        tapadore.setBackgroundImage(UIImage(named:"MinusUntapped"), for: .normal)
        taphappy.setBackgroundImage(UIImage(named:"PlusUntapped"), for: .normal)
        tapopeners.setBackgroundImage(UIImage(named:"QuestionUntapped"), for: .normal)
        tapunhappy.setBackgroundImage(UIImage(named:"ResponseUntapped"), for: .normal)
    }
    
    func tappedquestions() {
        
        tapmovies.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
        tapadore.setBackgroundImage(UIImage(named:"MinusUntapped"), for: .normal)
        taphappy.setBackgroundImage(UIImage(named:"PlusUntapped"), for: .normal)
        tapopeners.setBackgroundImage(UIImage(named:"QuestionTapped"), for: .normal)
        tapunhappy.setBackgroundImage(UIImage(named:"ResponseUntapped"), for: .normal)
    }
    
    func tappedpositive() {
        
        tapmovies.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
        tapadore.setBackgroundImage(UIImage(named:"MinusUntapped"), for: .normal)
        taphappy.setBackgroundImage(UIImage(named:"PlusTapped"), for: .normal)
        tapopeners.setBackgroundImage(UIImage(named:"QuestionUntapped"), for: .normal)
        tapunhappy.setBackgroundImage(UIImage(named:"ResponseUntapped"), for: .normal)
    }
    
    func tappedminus() {
        
        tapmovies.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
        tapadore.setBackgroundImage(UIImage(named:"MinusTapped"), for: .normal)
        taphappy.setBackgroundImage(UIImage(named:"PlusUntapped"), for: .normal)
        tapopeners.setBackgroundImage(UIImage(named:"QuestionUntapped"), for: .normal)
        tapunhappy.setBackgroundImage(UIImage(named:"ResponseUntapped"), for: .normal)
    }
    
    func tappedresponses() {
        
        tapmovies.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
        tapadore.setBackgroundImage(UIImage(named:"MinusUntapped"), for: .normal)
        taphappy.setBackgroundImage(UIImage(named:"PlusUntapped"), for: .normal)
        tapopeners.setBackgroundImage(UIImage(named:"QuestionUntapped"), for: .normal)
        tapunhappy.setBackgroundImage(UIImage(named:"ResponseTapped"), for: .normal)
    }
    
//    func addshit() {
//
//        var functioncounter = 0
//
//        while functioncounter < 25 {
//
//        ref?.child("Messages").child("Adore").childByAutoId().updateChildValues(["Text" : "Text2"])
//
//            functioncounter += 1
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startloading()
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        ref = Database.database().reference()

        
//        if Auth.auth().currentUser == nil {
//            // Do smth if user is not logged in
//
//            DispatchQueue.main.async {
//
//                self.performSegue(withIdentifier: "PlayToFirstName", sender: self)
//
//
//            }
//
//        } else {
        
            feeling = "Questions"
            
            queryforfeelings()
            tappedquestions()
            collectionView.collectionViewLayout = gridLayout

//        }

        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        
        return texts.count
        
        
//        return 5
        
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Texts", for: indexPath) as! TextsCollectionViewCell
        
        if texts.count > 0 {
            
            cell.textlabel.text = texts[responseids[indexPath.row]]
            
        }
        
        cell.image.image = UIImage(named: "Rectangle")
        
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        textDocumentProxy.insertText(texts[responseids[indexPath.row]]!)
        
        self.activeConversation?.insertText(texts[responseids[indexPath.row]]!, completionHandler: nil)
        
    }
    
    func updatetextsdictionary() {
        
        
        //
        //        responseids.append("1")
        //        responseids.append("2")
        //        responseids.append("3")
        //        responseids.append("4")
        //        responseids.append("5")
        //        responseids.append("6")
        //        responseids.append("7")
        //        responseids.append("8")
        //        responseids.append("9")
        //        responseids.append("10")
        //        responseids.append("11")
        //        responseids.append("12")
        //
        //
        //        texts["0"] = "Bless your heart"
        //        texts["1"] = "Fixin' To"
        //        texts["2"] = "Pretty as a peach"
        //        texts["3"] = "Hold your horses"
        //        texts["4"] = "Hissy Fit"
        //        texts["5"] = "I don't have a pot to piss in"
        //        texts["6"] = "Hard to beat"
        //        texts["7"] = "Good for the heart"
        //        texts["8"] = "Timing's everything"
        //        texts["9"] = "A girl no importance"
        //        texts["10"] = "Who would have thought?"
        //        texts["11"] = "I'm sadder than anyone"
        //        texts["12"] = "you know?"
        //        texts["13"] = "I'm gonna give them one hell"
        //        texts["14"] = "It's like I died and went to heaven"
        //        texts["15"] = "Now that's how it's done"
        //        texts["16"] = "Don't make me say it"
        //        texts["17"] = "You're being very rude right now"
        //        texts["18"] = "Need to lock you up and throw away the key"
        //
        //        self.collectionView.reloadData()
        
    }
    

}
