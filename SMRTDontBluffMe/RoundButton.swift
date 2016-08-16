//
//  RoundButton.swift
//  SMRTDontBluffMe
//
//  Created by IMAC on 15/8/16.
//  Copyright © 2016 Andrew Ng. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.7).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0 , height: 1.0)
        

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = 3.0
        
        
    }

}
