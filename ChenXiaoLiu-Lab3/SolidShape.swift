//
//  SolidShape.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/5.
//

final class SolidShape: Shape {
    override func draw() {
        constructPath()
        color.setFill()
        path.fill()
    }
}
