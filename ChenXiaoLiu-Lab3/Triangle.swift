//
//  Triangle.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/4.
//

import UIKit

final class Triangle: Shape {
    override func constructPath() {
        path.removeAllPoints()
        let distance = length / 2.0
        let height = sqrt(pow(length, 2) - pow(length / 2.0, 2))
        path.move(to: CGPoint(x: origin.x - distance, y: origin.y + height / 3.0))
        path.addLine(to: CGPoint(x: origin.x + distance, y: origin.y + height / 3.0))
        path.addLine(to: CGPoint(x: origin.x, y: origin.y - height / 3.0 * 2.0))
        path.rotate(by: rotation)
        path.close()
    }
}
