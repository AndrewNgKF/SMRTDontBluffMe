//
//  FeedVC.swift
//  SMRTDontBluffMe
//
//  Created by IMAC on 16/8/16.
//  Copyright © 2016 Andrew Ng. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signOutTapped(_ sender: AnyObject) {
        
    KeychainWrapper.removeObjectForKey(KEY_UID)
        
        print("Keychain removed")
        try! FIRAuth.auth()?.signOut()
        print("Firebase Signed out")
        
        performSegue(withIdentifier: "gotToSignIn", sender: nil)
        
    }
    

}
