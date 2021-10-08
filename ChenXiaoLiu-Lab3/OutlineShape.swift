//
//  OutlineShape.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/5.
//

final class OutlineShape: Shape {
    override func draw() {
        constructPath()
        color.setStroke()
        path.stroke()
    }
}
