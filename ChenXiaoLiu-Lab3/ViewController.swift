//
//  ViewController.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/3.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var canvas: DrawingView!
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    @IBOutlet var rotationGestureRecognizer: UIRotationGestureRecognizer!
    
    var color: Color! = .red
    var shape: ShapeType! = .square
    var inputMode: InputMode! = .draw
    var item: Shape! = nil
    var length: CGFloat = 75
    var rotation: CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinchGestureRecognizer.delegate = self
        rotationGestureRecognizer.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let touchPoint = touches.first?.location(in: canvas)
        else {
            return
        }
        
        switch inputMode {
        case .draw:
            item = shape.getInstance(touchPoint, color.getUIColor())
            canvas.items.append(item)
        case .move:
            if let item = canvas.itemAtLocation(touchPoint) as? Shape {
                self.item = item
            }
        case .erase:
            if let index = canvas.items.firstIndex(where: { $0 === canvas.itemAtLocation(touchPoint) }) {
                canvas.items.remove(at: index)
            }
        default:
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard inputMode == .move,
              touches.count == 1,
              item != nil,
              let touchPoint = touches.first?.location(in: canvas)
        else {
            return
        }
        item.origin = touchPoint
        canvas.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        item = nil
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
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        canvas.items = []
    }
    
    // Learned from https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_pinch_gestures
    @IBAction func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard sender.view != nil,
              inputMode == .move,
              item != nil
        else {
            return
        }
        if sender.state == .began {
            length = item.length
        }
        if sender.state == .changed {
            item.length = length * sender.scale
            canvas.setNeedsDisplay()
        }
    }
    
    // Learned from https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_rotation_gestures
    @IBAction func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
        guard sender.view != nil,
              inputMode == .move,
              item != nil
        else {
            return
        }
        if sender.state == .began {
            rotation = item.rotation
        }
        if sender.state == .changed {
            item.rotation = sender.rotation + rotation
            canvas.setNeedsDisplay()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
