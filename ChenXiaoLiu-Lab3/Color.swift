//
//  Color.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/4.
//

import UIKit

enum Color: Int {
    case red = 0
    case orange
    case yellow
    case green
    case blue
    case purple
    
    func getUIColor() -> UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .orange:
            return UIColor.orange
        case .yellow:
            return UIColor.yellow
        case .green:
            return UIColor.green
        case .blue:
            return UIColor.blue
        case .purple:
            return UIColor.purple
        }
    }
}
