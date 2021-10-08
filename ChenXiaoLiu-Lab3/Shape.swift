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
    var origin: CGPoint
    let color: UIColor
    let shape: Shapes
    let path = UIBezierPath()
    var length: CGFloat = 90
    var rotation: CGFloat = 0
    
    public required init(_ origin: CGPoint, _ color: UIColor, _ shape: Shapes) {
        self.origin = origin
        self.color = color
        self.shape = shape
    }
    
    required convenience init(origin: CGPoint, color: UIColor) {
        self.init(origin, color, .square)
    }
    
    func draw() {}
    
    final func constructPath() {
        path.removeAllPoints()
        let distance = length / 2.0
        
        switch shape {
        case .square:
            path.move(to: CGPoint(x: origin.x - distance, y: origin.y - distance))
            path.addLine(to: CGPoint(x: origin.x - distance, y: origin.y + distance))
            path.addLine(to: CGPoint(x: origin.x + distance, y: origin.y + distance))
            path.addLine(to: CGPoint(x: origin.x + distance, y: origin.y - distance))
        case .circle:
            path.addArc(
                withCenter: origin,
                radius: length / 2.0,
                startAngle: 0,
                endAngle: CGFloat(Float.pi * 2),
                clockwise: true
            )
        case .triangle:
            let height = sqrt(pow(length, 2) - pow(length / 2.0, 2))
            path.move(to: CGPoint(x: origin.x - distance, y: origin.y + height / 3.0))
            path.addLine(to: CGPoint(x: origin.x + distance, y: origin.y + height / 3.0))
            path.addLine(to: CGPoint(x: origin.x, y: origin.y - height / 3.0 * 2.0))
        }        
        path.rotate(by: rotation)
        path.close()
    }
    
    final func contains(point: CGPoint) -> Bool {
        return path.contains(point)
    }
}

extension UIBezierPath {
    func rotate(by angleRadians: CGFloat) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: angleRadians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        self.apply(transform)
    }
}
