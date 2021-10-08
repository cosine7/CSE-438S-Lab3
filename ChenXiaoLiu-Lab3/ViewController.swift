//
//  ViewController.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/3.
//

import UIKit
import LinkPresentation

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActivityItemSource {
    
    @IBOutlet weak var canvas: DrawingView!
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    @IBOutlet var rotationGestureRecognizer: UIRotationGestureRecognizer!
    @IBOutlet weak var shapeTypes: UISegmentedControl!
    
    var color: Color! = .red
    var shape: Shapes! = .square
    var inputMode: InputMode! = .draw
    var shapeType: ShapeType! = .solid
    var item: Shape! = nil
    var length: CGFloat = 75
    var rotation: CGFloat = 0
    var point = CGPoint(x: 0, y: 0)
    
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
            addItemToCanvasWith(origin: touchPoint)
        case .move:
            if let item = canvas.itemAtLocation(touchPoint) as? Shape {
                self.item = item
                self.point.x = item.origin.x - touchPoint.x
                self.point.y = item.origin.y - touchPoint.y
            }
        case .erase:
            if let index = canvas.items.firstIndex(
                where: { $0 === canvas.itemAtLocation(touchPoint) }
            ) {
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
        item.origin.x = point.x + touchPoint.x
        item.origin.y = point.y + touchPoint.y
        canvas.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        item = nil
    }

    @IBAction func colorDidChange(_ sender: UISegmentedControl) {
        color = Color(rawValue: sender.selectedSegmentIndex)
    }
    
    @IBAction func shapeDidChange(_ sender: UISegmentedControl) {
        shape = Shapes(rawValue: sender.selectedSegmentIndex)
    }
    
    @IBAction func inputModeDidChange(_ sender: UISegmentedControl) {
        inputMode = InputMode(rawValue: sender.selectedSegmentIndex)
    }
    
    @IBAction func shapeTypedidChange(_ sender: UISegmentedControl) {
        shapeType = ShapeType(rawValue: sender.selectedSegmentIndex)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        canvas.items = []
    }
    
    func addItemToCanvasWith(origin: CGPoint) {
        item = shapeType.getInstance(
            origin: origin,
            color: color.getUIColor(),
            shape: shape
        )
        canvas.items.append(item)
    }
    
    private func handleGesture(gesture: UIGestureRecognizer, onBegin: () -> Void, onChange: () -> Void) {
        guard gesture.view != nil,
              inputMode == .move,
              item != nil
        else {
            return
        }
        if gesture.state == .began {
            onBegin()
        }
        if gesture.state == .changed {
            onChange()
            canvas.setNeedsDisplay()
        }
        if gesture.state == .ended {
            item = nil
        }
    }
    
    // Learned from https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_pinch_gestures
    @IBAction func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        handleGesture(
            gesture: sender,
            onBegin: { length = item.length },
            onChange: { item.length = length * sender.scale }
        )
    }
    
    // Learned from https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_rotation_gestures
    @IBAction func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
        handleGesture(
            gesture: sender,
            onBegin: { rotation = item.rotation },
            onChange: { item.rotation = sender.rotation + rotation }
        )
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Learned from https://stackoverflow.com/questions/24190277/writing-handler-for-uialertaction
    @IBAction func optionButtonPressed(_ sender: Any) {
        let options = UIAlertController(
            title: "Options",
            message: nil,
            preferredStyle: .actionSheet
        )
        options.addAction(
            UIAlertAction(
                title: "Save Drawing to Photo Library",
                style: .default,
                handler: handleSaveDrawing
            )
        )
        options.addAction(
            UIAlertAction(
                title: "Choose Photo as canvas background",
                style: .default,
                handler: handleChoosePhoto
            )
        )
        options.addAction(
            UIAlertAction(
                title: "Share your drawing",
                style: .default,
                handler: handleShare
            )
        )
        options.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )
        present(options, animated: true)
    }
    
    // Learned from https://stackoverflow.com/questions/40854886/take-a-photo-and-save-to-photo-library-in-swift
    @objc func handleSaveDrawing(_ action: UIAlertAction) {
        UIImageWriteToSavedPhotosAlbum(
            canvas.asImage(),
            self,
            #selector(savingCompleted(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    @objc func handleShare(_ action: UIAlertAction) {
        share(items: [canvas.asImage(), self, "Check Out this Drawing!!!!"])
    }
    
    @objc func savingCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showMessage("Saving Failed", error.localizedDescription)
        } else {
            showMessage("Drawing Saved", "Your Drawing has been saved to Photo Library")
        }
    }
    
    func showMessage(_ title: String, _ content: String) {
        let message = UIAlertController(
            title: title,
            message: content,
            preferredStyle: .alert
        )
        message.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        present(message, animated: true)
    }

    // Learned from https://www.youtube.com/watch?v=yggOGEzueFk
    @objc func handleChoosePhoto(_ action: UIAlertAction) {
        let imagePicker = UIImagePickerController()

        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var title = "Failed"
        var content = "Failed to change canvas background"
        
        // Learned from https://stackoverflow.com/questions/31966885/resize-uiimage-to-200x200pt-px
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UIGraphicsBeginImageContext(
                CGSize(
                    width: canvas.frame.width,
                    height: canvas.frame.height
                )
            )
            image.draw(
                in: CGRect(
                    x: 0,
                    y: 0,
                    width: canvas.frame.width,
                    height: canvas.frame.height
                )
            )
            if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                canvas.backgroundColor = UIColor(patternImage: resizedImage)
                title = "Background Changed"
                content = "Canvas background has been changed!"
            }
            UIGraphicsEndImageContext()
        }
        showMessage(title, content)
    }
    
    // Learned from https://www.youtube.com/watch?v=jxhq1_7HkJg
    func share(items: [Any]) {
        let activityController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        present(activityController, animated: true)
    }
    
    // Learned from https://stackoverflow.com/questions/57850483/ios13-share-sheet-how-to-set-preview-thumbnail-when-sharing-uiimage
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Drawing"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.imageProvider = NSItemProvider(object: canvas.asImage())
        return metadata
    }
}

// Learned from https://stackoverflow.com/questions/30696307/how-to-convert-a-uiview-to-an-image
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }
    }
}
