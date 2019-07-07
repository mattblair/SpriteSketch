//
//  CoreGraphicsUtilities.swift
//  SpriteSketch
//
//  Created by Matt Blair on 7/1/19.
//  Copyright © 2019 Elsewise. All rights reserved.
//

import Foundation
import CoreGraphics


extension CGRect {
    
    /// Create a bounding rect for any two points.
    init(from pointA: CGPoint, to pointB: CGPoint) {
        
        let origin: CGPoint
        
        origin = CGPoint(x: min(pointA.x, pointB.x),
                         y: min(pointA.y, pointB.y))
    
        let width = abs(pointA.x - pointB.x)
        let height = abs(pointA.y - pointB.y)
    
        self.init(x: origin.x, y: origin.y, width: width, height: height)
    }
}

extension CGFloat {
    
    // Adapted from:
    // https://stackoverflow.com/a/48589764
    
    init?(string: String?) {
        
        guard let numberString = string else { return nil }
        
        guard let number = NumberFormatter().number(from: numberString) else {
            return nil
        }
        
        self.init(number.floatValue)
    }
}
