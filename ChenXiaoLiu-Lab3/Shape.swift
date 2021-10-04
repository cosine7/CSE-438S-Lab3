//
//  Shape.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU SHOULD MODIFY THIS FILE.
 
 Feel free to implement it however you want, adding properties, methods, etc. Your different shapes might be subclasses of this class, or you could store information in this class about which type of shape it is. Remember that you are partially graded based on object-oriented design. You may ask TAs for an assessment of your implementation.
 */

/// A `DrawingItem` that draws some shape to the screen.
class Shape: DrawingItem {
    var origin: CGPoint;
    var color: UIColor;
    
    public required init(origin: CGPoint, color: UIColor){
        self.origin = origin
        self.color = color
    }
    
    func draw() {}
    
    func contains(point: CGPoint) -> Bool {
        return true
    }
}
