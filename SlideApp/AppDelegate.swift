//
//  AppDelegate.swift
//  SlideApp
//
//  Created by Alek Matthiessen on 1/31/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import Purchases

var ref: DatabaseReference?

protocol SnippetsPurchasesDelegate: AnyObject {
    
    func purchaseCompleted(product: String)
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var purchases: Purchases?
    
    weak var purchasesdelegate : SnippetsPurchasesDelegate?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("Application did finish launching")
        
        FirebaseApp.configure()
        
        purchases = Purchases.configure(withAPIKey: "TwecCFVIQjxwkQTnJpsfLTgsAGyvVcKv", appUserID: nil)

        purchases!.delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func letsgo() {
        
        
        
        ref?.child("Users").child(uid).updateChildValues(["Purchased" : "Yes"])
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "Chat") as UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()//
        
    }
}

extension AppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, completedTransaction transaction: SKPaymentTransaction, withUpdatedInfo purchaserInfo: PurchaserInfo) {
        
        self.purchasesdelegate?.purchaseCompleted(product: transaction.payment.productIdentifier)
        
        
        
        ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
        letsgo()
        
    }
    
    func purchases(_ purchases: Purchases, receivedUpdatedPurchaserInfo purchaserInfo: PurchaserInfo) {
        //        handlePurchaserInfo(purchaserInfo)
        
        print(purchaserInfo)
        
    }
    
    func purchases(_ purchases: Purchases, failedToUpdatePurchaserInfoWithError error: Error) {
        print(error)
        
        
    }
    
    func purchases(_ purchases: Purchases, failedTransaction transaction: SKPaymentTransaction, withReason failureReason: Error) {
        print(failureReason)
        
        
    }
    
    func purchases(_ purchases: Purchases, restoredTransactionsWith purchaserInfo: PurchaserInfo) {
        //        handlePurchaserInfo(purchaserInfo)
        ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
        
        letsgo()
        
        
    }
    
    func purchases(_ purchases: Purchases, failedToRestoreTransactionsWithError error: Error) {
        print(error)
        
    }
}


class SegueFromLeft: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

class SegueFromRight: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}
