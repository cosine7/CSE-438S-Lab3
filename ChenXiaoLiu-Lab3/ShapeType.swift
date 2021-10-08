//
//  ShapeType.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/4.
//

import UIKit

enum ShapeType: Int {
    case solid = 0
    case outline
    
    func getInstance(origin: CGPoint, color: UIColor, shape: Shapes) -> Shape {
        switch self {
        case .solid:
            return SolidShape(origin, color, shape)
        case .outline:
            return OutlineShape(origin, color, shape)
        }
    }
}
