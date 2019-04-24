//
//  HomeViewController.swift
//  SlideApp
//
//  Created by Alek Matthiessen on 2/4/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit
import Messages
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import Purchases

var texts = [String:String]()
var textimages = [UIImage]()
var responseids = [String]()
var favoriteresponseids = [String]()

var feeling = String()
var feelingcolor = String()

var searchedtext = String()
var searchrelevantmessages = [String:String]()

var colors = [UIColor]()

var mypurple = UIColor(red:0.82, green:0.06, blue:0.59, alpha:1.0)
var myblue = UIColor(red:0.11, green:0.64, blue:0.96, alpha:1.0)
var mypink = UIColor(red:0.54, green:0.10, blue:0.80, alpha:1.0)
var myred = UIColor(red:0.91, green:0.32, blue:0.33, alpha:1.0)


class HomeViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var loadingbackground: UILabel!
//    var gridLayout: TextsFlowLayout = TextsFlowLayout(numberOfColumns: 2)

    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!

//    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tapfavorites: UIButton!
    @IBOutlet weak var tappositive: UIButton!
    @IBOutlet weak var addtextField: UITextField!
    @IBOutlet weak var tapsave: UIButton!
    @IBOutlet weak var taphello: UIButton!
    @IBOutlet weak var tapno: UIButton!
    
    @IBOutlet weak var backlabel: UIImageView!
    func startloading() {
        
      
    }
    func hideloading() {
        
       
    }
    
    @IBAction func tapNo(_ sender: Any) {
//        tappedNegative()
        feeling = "Negative"
        feelingcolor = "RedRectangle"
        collectionView.alpha = 1
        queryforfeelings()
        
    }
    @IBAction func tapHello(_ sender: Any) {
//        tappedHello()
        feeling = "Hello"
        feelingcolor = "BlueRectangle"
        collectionView.alpha = 1
        queryforfeelings()
    }
    @IBAction func tapAdd(_ sender: Any) {
//        tappedAdd()
        collectionView.alpha = 0
        addtextField.text = ""
    }
    
    @IBAction func tapPopular(_ sender: Any) {
//        tappedPositive()
        feeling = "Positive"
        feelingcolor = "GreenRectangle"
        collectionView.alpha = 1
        startloading()
        queryforfeelings()
    }
    @IBAction func tapFavorites(_ sender: Any) {
//        tappedFavorites()
        feeling = "Favorites"
        feelingcolor = "PurpleRectangle"
        collectionView.alpha = 1
        startloading()
        queryforfavorites()
        
    }
    @IBAction func tapLogOut(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        self.performSegue(withIdentifier: "HomeToAge", sender: self)


    }
    @IBAction func tapSave(_ sender: Any) {
        
        collectionView.alpha = 1
        
        ref?.child("Messages").child("Favorites").child(uid).childByAutoId().updateChildValues(["Text" : addtextField.text!])
        
        self.view.endEditing(true)
        
//       var newimage = convertextoimage(for: addtextField)
        
//        textimages.append(newimage)
//        collectionView.reloadData()
        
    }
    
    func queryforfeelingresponses() {
        
        var functioncounter = 0
        
        for each in responseids {
            
    ref?.child("Messages").child(selectedobjective).child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var topic = value?["Text"] as? String {

                    texts[each] = topic

                    var height = self.estimateFrameForText(text: topic).height + 5.0
                    
                    self.heights[each] = height
                    
                    print(height)
                    functioncounter += 1

                } else {
                    
                    
                    texts[each] = "Duh"
                    
                    var height = self.estimateFrameForText(text: "Duh").height + 5.0
                    
                    self.heights[each] = height
                    
                    functioncounter += 1

        }
        
        


        
        
                if functioncounter == responseids.count {
                    
                    self.hideloading()
                    self.collectionView.reloadData()
                    self.collectionView2.reloadData()
                }
            })
            
        }
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
                    self.hideloading()
                    self.collectionView.reloadData()
                    self.collectionView2.reloadData()
                }
            })
            
        }
    }
    
    func queryforresponseids(completed: @escaping ( () -> () )) {
        
        var functioncounter = 0
        
//        ref?.child("Messages").child(feeling).observeSingleEvent(of: .value, with: { (snapshot) in
        
        ref?.child("Messages").child(selectedobjective).observeSingleEvent(of: .value, with: { (snapshot) in

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
                
               self.hideloading()
                self.collectionView.reloadData()
                self.collectionView2.reloadData()
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
                
                self.hideloading()
                self.collectionView.reloadData()
                self.collectionView2.reloadData()
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
        
        queryforresponseids { () -> () in
            
            self.queryforfeelingresponses()
            
        }
    }
    

    
    func querydictionarybysearch() {
        
        var functioncounter = 0
        
//        searchedtext = searchTextField.text!
        
        
        for each in responseids {
            
            if (texts[each]?.contains(searchedtext))! {
                
//                searchrelevantmessages[each] = texts[each]
                
                functioncounter += 1

            } else {
                
                texts.removeValue(forKey: each)
                
                functioncounter += 1

                if functioncounter == responseids.count {
                    
                    self.hideloading()
                    collectionView.reloadData()
                    self.collectionView2.reloadData()
                }
            }
            
            
        }
        
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
        
            var resizedimage = self.resizeImage(image: image!, targetSize: CGSize(width: 200.0, height: 80.0))

            return resizedimage ?? UIImage()
        }

    var gl:CAGradientLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.layer.cornerRadius = 5.0
        objectives.removeAll()
        
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.white.cgColor
//        try! Auth.auth().signOut()
        
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
        
   
//        objectives.append("Tinder Openers")
//        objectives.append("Instagram DMs")
//        objectives.append("Booty Calls")
//        objectives.append("Snap Captions")
//        objectives.append("Feels")
//        objectives.append("Apologies")
//        objectives.append("Breakups")
//        objectives.append("Ghosts")
        
                objectives.append("Popular")
                objectives.append("Openers")
                objectives.append("Feels")
                objectives.append("Yes")
                objectives.append("No")
                objectives.append("Celebrate")
        
        
        colors.append(mypurple)
        selectedobjective = "Popular"
        ref = Database.database().reference()
        
//        searchTextField.delegate = self
//        searchTextField.returnKeyType = .done
        
        
        if Auth.auth().currentUser == nil {

            
            queryforfeelings()
            showpurchase()
            
        } else {

            uid = Auth.auth().currentUser!.uid
            
            
            queryforfeelings()
            hidepurchase()

            
        }

        
        // Do any additional setup after loading the view.
        
    }
    
    func newuser() {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        

        
    }
    
    
    var purchases = Purchases.configure(withAPIKey: "TwecCFVIQjxwkQTnJpsfLTgsAGyvVcKv", appUserID: nil)

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 2 {
            
            return objectives.count
            
        } else {
        
        if texts.count > 0 {
        
            return texts.count
            
        } else {
            
            return 1
        }
        
        }
        //        return 5
        
    }
    @IBOutlet weak var termslabel: UILabel!
    
    @IBAction func tapPurchase(_ sender: Any) {
        
        
        purchases.entitlements { (entitlements, error) in
            guard let pro = entitlements?["premium"] else { return }
            guard let monthly = pro.offerings["monthly"] else { return }
            guard let product = monthly.activeProduct else { return }
            
            self.purchases.makePurchase(product, { (transaction, purchaserInfo, error, cancelled) in
                if let purchaserInfo = purchaserInfo {
                    
                    print("x")

                    
                    if purchaserInfo.activeEntitlements.contains("my_entitlement_identifier") {
                        // Unlock that great "pro" content
                        
                        self.performSegue(withIdentifier: "PayToCreate", sender: self)

                        print("n")
                    } else {
                        
                        self.performSegue(withIdentifier: "PayToCreate", sender: self)

                        print("y")
                    }
                    
                } else {
                    
                    self.performSegue(withIdentifier: "PayToCreate", sender: self)

                    print("n")
                }
            })
         
        }
    }
    @IBAction func tapTerms(_ sender: Any) {
    }
    @IBOutlet weak var tapterms: UIButton!
    @IBOutlet weak var popular: UIImageView!
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var tappurchase: UIButton!
    
    func hidepurchase() {
        
        tapterms.alpha = 0
        pricelabel.alpha = 0
        tappurchase.alpha = 0
        backlabel.alpha = 0
        popular.alpha = 0
        termslabel.alpha = 0
        
        collectionView.isUserInteractionEnabled = true
    }
    
    func showpurchase() {
        tapterms.alpha = 1
        pricelabel.alpha = 1
        tappurchase.alpha = 1
        backlabel.alpha = 1
        popular.alpha = 1
        termslabel.alpha = 1
       tappurchase.layer.cornerRadius = 22.0
        tappurchase.clipsToBounds = true
        collectionView.isUserInteractionEnabled = false
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath) as! CategoriesCollectionViewCell
            
            cell.titlelabel.text = objectives[indexPath.row]
            //            cell.titlelabel.sizeToFit()
            
            cell.selectedimage.layer.cornerRadius = 5.0
            cell.selectedimage.layer.masksToBounds = true
            collectionView2.alpha = 1
            
            if selectedindex == 0 {
                
                if indexPath.row == 0 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 1 {
                
                if indexPath.row == 1 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 2 {
                
                if indexPath.row == 2 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 3 {
                
                if indexPath.row == 3 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 4 {
                
                if indexPath.row == 4 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 5 {
                
                if indexPath.row == 5 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 6 {
                
                if indexPath.row == 6 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 7 {
                
                if indexPath.row == 7 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            return cell

            
        } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Texts", for: indexPath) as! AppTextsCollectionViewCell
        
        if texts.count > indexPath.row {
            
            cell.textlabel.text = texts[responseids[indexPath.row]]
            
            cell.image.layer.cornerRadius = 15.0
            cell.image.clipsToBounds = true
            cell.little.alpha = 1
            cell.little.clipsToBounds = true
//            cell.image.image = UIImage(named: "PurpleChatBubble")

//            cell.textlabel.sizeToFit()
//
//            // Customize cell height
            
//            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: cell.textlabel.frame.height)
            
            return cell
            
        } else {
            
//            cell.textlabel.text = "You have no \(feeling) messages yet."
//            cell.image.image = UIImage(named: "PurpleChatBubble")
            return cell

        }
        
        }
        
        // Configure the cell
    }
    
    @IBOutlet weak var collectionView2: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 2 {
            
            return CGSize(width: 141, height: 66)

            
        } else {
        var height: CGFloat = 500
        
        //we are just measuring height so we add a padding constant to give the label some room to breathe!
        var padding: CGFloat = 5
        
        //estimate each cell's height
        
        var screenSize = collectionView.bounds
        var screenWidth = screenSize.width
        var screenHeight = screenSize.height
        
        var columnwidth = (screenSize.width/2) - 5
        
        if texts.count > indexPath.row {
        
        if let text2 = texts[responseids[indexPath.item]] {
            
            
            height = text2.height(constraintedWidth: columnwidth-5, font: UIFont.systemFont(ofSize: 18)) + 45
            
            
            print(height)
            
            print("Yup")
            
        } else {
            
            print("No1")
            }
        
        } else {
            
            height = 200
            
            print("No2")

        }
        
            if height < 74 {
                
                height = 74
                
            } else {
                
                
            }
            
        return CGSize(width: columnwidth, height: height)
            
        }

    }
  
    
    var heights = [String:CGFloat]()
    
     func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 500
        
        let size = CGSize(width: 181, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    var selectedindex = Int()
    var selectedobjective = String()
    var objectives = [String]()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        textDocumentProxy.insertText(texts[responseids[indexPath.row]]!)
        
        if collectionView.tag == 2 {
            
            selectedindex = indexPath.row
            
            collectionView2.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            
            
                selectedobjective = objectives[indexPath.row]
    
                queryforfeelings()
                
                
                collectionView2.reloadData()
                
            } else {
        ref?.child("SentMessage").child(uid).childByAutoId().updateChildValues(["Text" : [responseids[indexPath.row]]])
        
        ref?.child("Messages").child("Favorites").child(uid).childByAutoId().updateChildValues(["Text" : texts[responseids[indexPath.row]]])
        
        let cell = collectionView.cellForItem(at: indexPath) as! AppTextsCollectionViewCell
    
//        cell.image.image = UIImage(named: "BlackChatBubbleSmall")
        
//        var selectedcell = convertextoimage(for: cell)
        

        let activityVC = UIActivityViewController(activityItems: [texts[responseids[indexPath.row]]], applicationActivities: nil )
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
        }
        
    }
//        UIPasteboard.general.image = selectedcell
        
//        guard let messageAppURL = NSURL(string: "sms:")
//            else { return }
//        if UIApplication.shared.canOpenURL(messageAppURL as URL) {
//            UIApplication.shared.openURL(messageAppURL as URL)
//        }
        
    


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        

        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        if searchTextField.text != "" {
//
//            searchedtext = searchTextField.text!
//            querydictionarybysearch()
//
//
//        }
//
//        self.view.endEditing(true)

        return true
    }
    
    
    func tappedHello() {
        
                tapfavorites.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
                tapno.setBackgroundImage(UIImage(named:"NegativeUntapped"), for: .normal)
                tappositive.setBackgroundImage(UIImage(named:"PositiveUntapped"), for: .normal)
                taphello.setBackgroundImage(UIImage(named:"HelloTapped"), for: .normal)

    }
    
    func tappedNegative() {
        tapfavorites.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
        tapno.setBackgroundImage(UIImage(named:"NegativeTapped"), for: .normal)
        tappositive.setBackgroundImage(UIImage(named:"PositiveUntapped"), for: .normal)
        taphello.setBackgroundImage(UIImage(named:"HelloUntapped"), for: .normal)

    }
    
    func tappedPositive() {
        
        tapfavorites.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
        tapno.setBackgroundImage(UIImage(named:"NegativeUntapped"), for: .normal)
        tappositive.setBackgroundImage(UIImage(named:"PositiveTapped"), for: .normal)
        taphello.setBackgroundImage(UIImage(named:"HelloUntapped"), for: .normal)
    }
    
    func tappedFavorites() {
        
        tapfavorites.setBackgroundImage(UIImage(named: "FavoritesTapped"), for: .normal)
        tapno.setBackgroundImage(UIImage(named:"NegativeUntapped"), for: .normal)
        tappositive.setBackgroundImage(UIImage(named:"PositiveUntapped"), for: .normal)
        taphello.setBackgroundImage(UIImage(named:"HelloUntapped"), for: .normal)
    }
    
    func tappedAdd() {
        
        tapfavorites.setBackgroundImage(UIImage(named: "FavoritesUntapped"), for: .normal)
        tapno.setBackgroundImage(UIImage(named:"NegativeUntapped"), for: .normal)
        tappositive.setBackgroundImage(UIImage(named:"PositiveUntapped"), for: .normal)
        taphello.setBackgroundImage(UIImage(named:"HelloUntapped"), for: .normal)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
