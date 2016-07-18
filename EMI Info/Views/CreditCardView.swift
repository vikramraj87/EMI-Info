import UIKit

class CreditCardUnderlyingLayer: CALayer {
    var stripes: CAShapeLayer?
    
    override func display() {
        cornerRadius = bounds.width * 3.48 / 85.60
        
        // Stripes
        
        let stripes = CAShapeLayer()
        stripes.contentsScale = UIScreen.main().scale
        stripes.frame = bounds
        stripes.fillColor = nil
        stripes.strokeColor = UIColor.white().cgColor
        stripes.opacity = 0.1
        stripes.path = getStripes().cgPath
        stripes.needsDisplayOnBoundsChange = true
        self.stripes = stripes
        addSublayer(stripes)
    }
    
    override func layoutSublayers() {
        stripes?.path = getStripes().cgPath
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
        endPoint.y = 0.26 * bounds.height
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
    override var backgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = backgroundColor?.cgColor
            setNeedsDisplay()
        }
    }
    
    override class func layerClass() -> AnyClass {
        return CreditCardUnderlyingLayer.self
    }
    
    override func draw(_ rect: CGRect) {
        // The layer will draw itself
    }
    
    private func setupView() {
        layer.cornerRadius = bounds.width * 3.48 / 85.60
    }
    
    private func createStripesLayer() -> CAShapeLayer {
        let stripes = CAShapeLayer()

        // It's Our responsibility to set the content scale for layers other than the underlying layer
        stripes.contentsScale = UIScreen.main().scale
        stripes.frame = bounds
        stripes.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
        stripes.fillColor = nil
        stripes.path = getStripes().cgPath
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
