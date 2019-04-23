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

var uid = String()

var counter = Int()

class MessagesViewController: MSMessagesAppViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundlabel: UILabel!
    @IBOutlet weak var messagecopiedlabel: UILabel!
    @IBOutlet weak var tapCompliments: UIButton!
    @IBOutlet weak var tapPopular: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tapFlirty: UIButton!
    @IBOutlet weak var tapadd: UIButton!
    @IBOutlet weak var tappopular: UIButton!
    @IBOutlet weak var tapfavorites: UIButton!
    @IBAction func tapFavorites(_ sender: Any) {
        
        collectionView.alpha = 1
//        tappedfavorites()
        feeling = "Favorites"
        tapsave.alpha = 0
        textFIeld.alpha = 0
        queryforfavorites()
    }
    var gridLayout: TextsFlowLayout = TextsFlowLayout(numberOfColumns: 2)

    @IBOutlet weak var loginlabel: UILabel!
    @IBOutlet weak var loadingBackground: UILabel!
    
    var timer = Timer()
        
    
    @IBOutlet weak var tapsave: UIButton!
    @IBOutlet weak var textFIeld: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func tapSave(_ sender: Any) {
        
        ref?.child("Submissions").child(uid).childByAutoId().updateChildValues(["Text" : textFIeld.text!])
        
        collectionView.alpha = 1
        
        feeling = "Popular"
        tappedpopular()
        
        queryforfeelings()
        
        ref?.child("Messages").child("Favorites").child(uid).childByAutoId().updateChildValues(["Text" : textFIeld.text!])
        
        self.view.endEditing(true)
        
        requestPresentationStyle(.compact)
        
    }
    @IBAction func tapPopular(_ sender: Any) {
        collectionView.alpha = 1
        tapsave.alpha = 0
        textFIeld.alpha = 0
        feeling = "Popular"
        tappedpopular()

        queryforfeelings()
        
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        
        tappedadd()
        collectionView.alpha = 0
        tapsave.alpha = 1
        textFIeld.alpha = 1
        textFIeld.text = ""
        requestPresentationStyle(.expanded)
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
    
    func queryforfavoriteresponses() {
        
        var functioncounter = 0
        
        for each in responseids {
            
            ref?.child("Messages").child("Favorites").child(uid).child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var topic = value?["Text"] as? String {
                    
                    texts[each] = topic
                    
                }
                
                functioncounter += 1
                
                if functioncounter == responseids.count {
                    
                    self.collectionView.reloadData()
                }
            })
            
        }
    }
    
    func queryforfeelingresponses() {
        
        var functioncounter = 0
        
        for each in responseids {
            
            ref?.child("Messages").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
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
        
//        ref?.child("Messages").child(feeling).observeSingleEvent(of: .value, with: { (snapshot) in
        
        ref?.child("Messages").observeSingleEvent(of: .value, with: { (snapshot) in

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
    
    func queryforsubmitedresponseids(completed: @escaping ( () -> () )) {
        
        var functioncounter = 0
        
        ref?.child("Messages").child("Favorites").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    responseids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        completed()
                        
                    }
                    
                    
                }
                
            } else {
                
                self.collectionView.reloadData()
            }
            
        })
        
        
    }
    
   
    
    func queryforfavorites() {
        
        responseids.removeAll()
        texts.removeAll()
        
        queryforsubmitedresponseids { () -> () in
            
            self.queryforfavoriteresponses()
            
        }
    }
    
    func queryforfeelings() {
        
        responseids.removeAll()
        texts.removeAll()
        
        startloading()
        queryforresponseids { () -> () in
            
            self.queryforfeelingresponses()
            
        }
    }
    
    @objc func addcounter() {
        
        counter += 1
        
        if counter > 3 {
            
            timer.invalidate()
            counter = 0
            messagecopiedlabel.alpha = 0
            backgroundlabel.alpha = 0
        }
    }
    
    func showcopied() {
        
        messagecopiedlabel.alpha = 1
        backgroundlabel.alpha = 1
        
        
    }
    
    func tappedadd() {
        
        
    }
    
    func tappedfavorites() {
        
        
    }
    
    func tappedpopular() {
        
        
    }
    
    
    func tappedFlirty() {
//
//        tapFavorites.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
//        tapCompliments.setBackgroundImage(UIImage(named:"ComplimentsUntapped"), for: .normal)
//        tapPopular.setBackgroundImage(UIImage(named:"PlusUntapped"), for: .normal)
//        tapAdd.setBackgroundImage(UIImage(named:"MinusUntapped"), for: .normal)
//        tapFlirty.setBackgroundImage(UIImage(named:"ResponseUntapped"), for: .normal)
    }
    
    func tappedAffirmative() {
//
//        tapFavorites.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
//        tapCompliments.setBackgroundImage(UIImage(named:"ComplimentsUntapped"), for: .normal)
//        tapPopular.setBackgroundImage(UIImage(named:"PlusTapped"), for: .normal)
//        tapAdd.setBackgroundImage(UIImage(named:"QuestionUntapped"), for: .normal)
//        tapFlirty.setBackgroundImage(UIImage(named:"ResponseUntapped"), for: .normal)
    }
    
    func tappedCompliments() {
        
//        tapFavorites.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
//        tapCompliments.setBackgroundImage(UIImage(named:"ComplimentsTapped"), for: .normal)
//        tapPopular.setBackgroundImage(UIImage(named:"PlusUntapped"), for: .normal)
//        tapAdd.setBackgroundImage(UIImage(named:"MinusUntapped"), for: .normal)
//        tapFlirty.setBackgroundImage(UIImage(named:"ResponseUntapped"), for: .normal)
    }
    
    func tappedresponses() {
        
//        tapFavorites.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
//        tapCompliments.setBackgroundImage(UIImage(named:"ComplimentsUntapped"), for: .normal)
//        tapPopular.setBackgroundImage(UIImage(named:"PlusUntapped"), for: .normal)
//        tapAdd.setBackgroundImage(UIImage(named:"MinusUntapped"), for: .normal)
//        tapFlirty.setBackgroundImage(UIImage(named:"ResponseTapped"), for: .normal)
    }
    
//    func addshit() {
//
//        var functioncounter = 0
//
//        while functioncounter < 25 {
//
//        ref?.child("Messages").child("Popular").childByAutoId().updateChildValues(["Text" : "Text2"])
//
//            functioncounter += 1
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startloading()
                
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        ref = Database.database().reference()

        let storagePath = UserDefaults.standard.object(forKey: "uid") as? String

        var defaults = UserDefaults(suiteName: "group.com.aatech.Slide")

        defaults?.synchronize()
        
        counter = 0
        
        messagecopiedlabel.alpha = 0
        backgroundlabel.alpha = 0
        
        if defaults!.string(forKey: "uid") == nil {
            // Do smth if user is not logged in

            collectionView.alpha = 0
            textFIeld.alpha = 0
            tapsave.alpha = 0
            loginlabel.alpha = 1
            tapadd.alpha = 0
            tapfavorites.alpha = 0
            tappopular.alpha = 0
            hideloading()
            
        } else {
        
            feeling = "Popular"
            textFIeld.delegate = self as! UITextFieldDelegate
            tapadd.alpha = 1
            tapfavorites.alpha = 1
            tappopular.alpha = 1
            uid = defaults!.string(forKey: "uid")!
            
            collectionView.alpha = 1
            loginlabel.alpha = 0
            
            queryforfeelings()
//            tappedFlirty()
            collectionView.collectionViewLayout = gridLayout

//        }

        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func convertextoimage(for view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        if view.responds(to: Selector("drawViewHierarchyInRect:afterScreenUpdates:")) {
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        else {
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        // ... otherwise, fall back to tried and true methods
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var resizedimage = self.resizeImage(image: image!, targetSize: CGSize(width: 350.0, height: 140.0))
        
        return resizedimage ?? UIImage()
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
        
        
        if texts.count > 0 {
            
            return texts.count
            
        } else {
            
            return 1
        }
        
        
//        return 5
        
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Texts", for: indexPath) as! TextsCollectionViewCell
        
        if texts.count > 0 {
            
            cell.textlabel.text = texts[responseids[indexPath.row]]
            
            cell.image.image = UIImage(named: "PurpleChatBubble")

        } else {
            
            cell.textlabel.text = "You have no \(feeling) messages yet."
        }
        
        
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ref?.child("SentMessage").child(uid).childByAutoId().updateChildValues(["Text" : [texts[responseids[indexPath.row]]]])
        
        ref?.child("Messages").child("Favorites").child(uid).childByAutoId().updateChildValues(["Text" : texts[responseids[indexPath.row]]])
        
        let cell = collectionView.cellForItem(at: indexPath) as! TextsCollectionViewCell
        
//        var selectedcell = convertextoimage(for: cell)

//        UIPasteboard.general.string = texts[responseids[indexPath.row]]]
        
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MessagesViewController.addcounter), userInfo: nil, repeats: true)

//        showcopied()
        
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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}
