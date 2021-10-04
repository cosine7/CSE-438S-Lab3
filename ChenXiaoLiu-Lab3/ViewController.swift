//
//  ViewController.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/3.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var canvas: DrawingView!
    
    var color: Color! = .red
    var shape: ShapeType! = .square
    var inputMode: InputMode! = .draw
    var item: Shape! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = (touches.first)!.location(in: canvas) as CGPoint
        item = shape.getInstance(point, color.getUIColor())
        canvas.items.append(item)
    }

    @IBAction func colorDidChange(_ sender: UISegmentedControl) {
        color = Color(rawValue: sender.selectedSegmentIndex)
    }
    
    @IBAction func shapeDidChange(_ sender: UISegmentedControl) {
        shape = ShapeType(rawValue: sender.selectedSegmentIndex)
    }
    
    @IBAction func inputModeDidChange(_ sender: UISegmentedControl) {
        inputMode = InputMode(rawValue: sender.selectedSegmentIndex)
    }
}
