//
//  Post.swift
//  SMRTDontBluffMe
//
//  Created by IMAC on 17/8/16.
//  Copyright © 2016 Andrew Ng. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _haha: Int!
    private var _grrr: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }

    var imageUrl: String {
        return _imageUrl
    }
    
    var haha: Int {
        return _haha
    }
 
    var grrr: Int {
        return _grrr
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, haha: Int, grrr: Int) {
        _caption = caption
        _imageUrl = imageUrl
        _haha = haha
        _grrr = grrr
        
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        _postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let haha = postData["haha"] as? Int{
            self._haha = haha
        }
        
        if let grrr = postData["grrr"] as? Int {
            self._grrr = grrr
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    
    func adjustHaha(addhaha: Bool) {
        
        if addhaha {
            _haha = _haha + 1
        } else {
            _haha = _haha + 1
        }
        
        _postRef.child("haha").setValue(_haha)
        
    }
    
    
    
    
    
}





