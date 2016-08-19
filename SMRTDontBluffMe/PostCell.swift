//
//  PostCell.swift
//  SMRTDontBluffMe
//
//  Created by IMAC on 17/8/16.
//  Copyright © 2016 Andrew Ng. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    
    @IBOutlet weak var hahaBtn: UIButton!
    @IBOutlet weak var grrrBtn: UIButton!
    
    @IBOutlet weak var hahaLbl: UILabel!
    @IBOutlet weak var grrrLbl: UILabel!
    
    var post: Post!
    
    var hahaRef: FIRDatabaseReference!
   
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        
        hahaRef = DataService.ds.REF_USER_CURRENT.child("haha").child(post.postKey)
        
        /*
        self.hahaLbl.text = "\(post.haha)"
        self.grrrLbl.text = "\(post.grrr)"
        */
        
        if img != nil {
            
            self.postImg.image = img
            
        } else {
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("Unable to download image fr firebase storage \(error)")
                } else {
                    
                   print ("Image downloaded from firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            
                            
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl)
                        }
                    }
                    
                }
                
                
            })
            
            
        }
        

        hahaRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
            if let _ = snapshot.value as? NSNull {
                
                
                
            }
        
        })
    
    }
    
    func hahaTapped() {
        
        hahaRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                self.post.adjustHaha(addhaha: true)
                
                self.hahaRef.setValue(true)
                
            } else {
                self.post.adjustHaha(addhaha: false)
                self.hahaRef.removeValue()
            }
            
        })
        
    }
    
    
    
    
}
    
    
    
    
    
    
    
    
    
    
    
    

