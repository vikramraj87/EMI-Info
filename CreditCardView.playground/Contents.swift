//: Playground - noun: a place where people can play

import UIKit
import CoreGraphics

class CreditCardUnderlyingLayer: CALayer {
    var stripes: CAShapeLayer!
    
    override func display() {
        self.cornerRadius = min(bounds.width, bounds.height)/20
        stripes = createStripesLayer()
        self.addSublayer(stripes)
    }
    
    private func createStripesLayer() -> CAShapeLayer {
        let stripes = CAShapeLayer()
        
        // It's Our responsibility to set the content scale for layers other than the underlying layer
        stripes.contentsScale = UIScreen.main().scale
        stripes.frame = bounds
        stripes.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
        stripes.fillColor = nil
        stripes.path = getStripes().cgPath
        stripes.opacity = 0.2
        
        return stripes
    }
    
    private func getStripes() -> UIBezierPath {
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: 0, y: 0.85 * bounds.height)
        var endPoint = CGPoint(x: bounds.width, y: 0.22 * bounds.height)
        var controlPoint1 = CGPoint(x: 0.85 * bounds.width, y: -0.3 * bounds.height)
        let controlPoint2 = CGPoint(x: 0.5 * bounds.width, y: bounds.height)
        addStripe(to: path, from: startPoint, to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
//        startPoint.y = 0.87 * bounds.height
        endPoint.y = 0.24 * bounds.height
        controlPoint1.y = -0.2 * bounds.height
        addStripe(to: path, from: startPoint, to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
//        startPoint.y = 0.88 * bounds.height
        endPoint.y = 0.28 * bounds.height
        controlPoint1.y = -0.1 * bounds.height
        addStripe(to: path, from: startPoint, to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        return path
    }
    
    private func addStripe(to path: UIBezierPath, from startPoint: CGPoint, to endPoint: CGPoint, controlPoint1 cp1: CGPoint, controlPoint2 cp2: CGPoint) {
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    }
}

@IBDesignable
class CreditCardView: UIView {
    @IBInspectable
    var layerColor: UIColor! {
        didSet {
            layer.backgroundColor = layerColor.cgColor
        }
    }
    
    override class func layerClass() -> AnyClass {
        return CreditCardUnderlyingLayer.self
    }
    
    override func draw(_ rect: CGRect) {
        
    }
}

let colors = [
    UIColor(colorLiteralRed: 1/255, green: 38/255, blue: 54/255, alpha: 1.0),
    UIColor(colorLiteralRed: 22/255, green: 51/255, blue: 101/255, alpha: 1),
    UIColor(colorLiteralRed: 3/255, green: 86/255, blue: 138/255, alpha: 1),
    UIColor(colorLiteralRed: 0/255, green: 46/255, blue: 26/255, alpha: 1),
    UIColor(colorLiteralRed: 19/255, green: 19/255, blue: 19/255, alpha: 1),
    UIColor(colorLiteralRed: 164/255, green: 0/255, blue: 71/255, alpha: 1),
    UIColor(colorLiteralRed: 9/255, green: 25/255, blue: 48/255, alpha: 1),
    UIColor(colorLiteralRed: 220/255, green: 100/255, blue: 22/255, alpha: 1),
    UIColor(colorLiteralRed: 139/255, green: 31/255, blue: 32/255, alpha: 1)
]

let view = CreditCardView(frame: CGRect(x: 0, y: 0, width: 600, height: 400))
view.layerColor = colors[0]
view
//
//view.layerColor = colors[1]
//view
//
//view.layerColor = colors[2]
//view
//
//view.layerColor = colors[3]
//view
//
//view.layerColor = colors[4]
//view
//
//view.layerColor = colors[5]
//view
//
//view.layerColor = colors[6]
//view
//
//view.layerColor = colors[7]
//view
//
//view.layerColor = colors[8]
//view
//
