//
//  FancyField.swift
//  SMRTDontBluffMe
//
//  Created by IMAC on 15/8/16.
//  Copyright © 2016 Andrew Ng. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.7).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 3.0
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)

    }
}
