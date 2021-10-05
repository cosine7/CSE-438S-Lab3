//
//  Circle.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/4.
//

import UIKit

final class Circle: Shape {
    override func constructPath() {
        path.removeAllPoints()
        path.addArc(
            withCenter: origin,
            radius: length / 2.0,
            startAngle: 0,
            endAngle: CGFloat(Float.pi * 2),
            clockwise: true
        )
        path.close()
    }
}
