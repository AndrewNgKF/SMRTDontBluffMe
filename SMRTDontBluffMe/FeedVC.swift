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

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageAdd: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var captionField: UITextField!
    
    
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
        
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print(snap)
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl) {
                
                cell.configureCell(post: post, img: img)
                return cell

            } else {
                cell.configureCell(post: post)
                return cell
            }
            
            
            return cell
            
        } else {
            return PostCell()
        }
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageSelected = true
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
            
        } else {
            print("Valid Image not selected")
            
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        let keychainResult = KeychainWrapper.removeObjectForKey(KEY_UID)
        
        print("Keychain removed")
        try! FIRAuth.auth()?.signOut()
        print("Firebase Signed out")
        
        performSegue(withIdentifier: "gotToSignIn", sender: nil)
        
    }
    
    func postToFirebase(imgUrl: String) {
        
        
        let post: Dictionary<String, AnyObject> = [
        
            "caption": captionField.text!,
            "imageUrl": imgUrl,
        
            "haha": 0,
            "grrr": 0
        
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        
        //check name again
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
        
    }
    
   
    @IBAction func addImageTapped(_ sender: AnyObject) {
        
        

        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postBtnTapped(_ sender: AnyObject) {
        
        
        guard let caption = captionField.text, captionField != "" else {
            
            print("Caption must be entered")
            
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            print("select an image?")
            return
        }
        
        
        // convert the image into lower format
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metaData) {(metadata, error) in
                
                if error != nil {
                    print("Unable to upload to firebase storage")
                } else {
                    print("successfully uploaded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)

                    }
                }
                
            }
            
        }
        
        
    }
    
    

}
