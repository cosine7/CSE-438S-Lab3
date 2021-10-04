//
//  Square.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/4.
//

import UIKit
final class Square: Shape {
    override func draw() {
        color.setFill()
        let path = UIBezierPath(rect: CGRect(x: origin.x - 10, y: origin.y - 10, width: 20, height: 20))
        
        path.fill()
    }
}
