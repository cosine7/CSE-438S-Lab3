//
//  Square.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/4.
//

import UIKit

final class Square: Shape {
    override func constructPath() {
        path.removeAllPoints()
        let distance = length / 2.0
        path.move(to: CGPoint(x: origin.x - distance, y: origin.y - distance))
        path.addLine(to: CGPoint(x: origin.x - distance, y: origin.y + distance))
        path.addLine(to: CGPoint(x: origin.x + distance, y: origin.y + distance))
        path.addLine(to: CGPoint(x: origin.x + distance, y: origin.y - distance))
        path.rotate(by: rotation)
        path.close()
    }
}
