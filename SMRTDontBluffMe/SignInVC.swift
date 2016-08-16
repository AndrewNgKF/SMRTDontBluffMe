//
//  SignInVC.swift
//  SMRTDontBluffMe
//
//  Created by IMAC on 15/8/16.
//  Copyright © 2016 Andrew Ng. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!

    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.stringForKey(KEY_UID) {
            print("ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }
    }

   
    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) {(result, error) in
            
            if error != nil {
                print ("Unable to authenticate with fb")
            } else if result?.isCancelled == true {
                print("user cancelled FB authentication")
            }else {
                print("user logged in")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { ( user, error) in
        
            if error != nil {
                print ("Unable to authenticate with Firebase")
            } else {
                print("Successfully authenticated with Firebase")
                
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
                
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    
                    print("Email user authticated with Firebase")
                    
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }

                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            print ("unable to authenticate with firebase email")
                        } else {
                            print ("successfully created email with firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.setString(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)

    }
    
    
}

