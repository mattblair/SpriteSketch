//
//  SelectionView.swift
//  SpriteSketch
//
//  Created by Matt Blair on 7/7/19.
//  Copyright © 2019 Elsewise. All rights reserved.
//

import UIKit

class SelectionView: UIView {
    
    // slightly transparent red
    var borderColor: CGColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 0.8)
    
    init(borderColor bc: UIColor) {
        borderColor = bc.cgColor
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    private func setup() {
        
        layer.borderColor = borderColor
        layer.borderWidth = 1.0
        backgroundColor = .clear
        layer.masksToBounds = true
    }
}
