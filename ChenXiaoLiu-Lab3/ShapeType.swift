//
//  ShapeType.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/4.
//

//import Foundation
import UIKit

enum ShapeType: Int {
    case square = 0
    case circle
    case triangle
    
    func getInstance(_ point: CGPoint, _ color: UIColor) -> Shape {
        switch self {
        case .square:
            return Square(origin: point, color: color)
        case .circle:
            return Circle(origin: point, color: color)
        case .triangle:
            return Triangle(origin: point, color: color)
        }
    }
}
