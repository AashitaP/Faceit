  //
//  FaceView.swift
//  Faceit
//
//  Created by Aashita on 9/11/17.
//  Copyright © 2017 aashita. All rights reserved.
//

import UIKit
  
@IBDesignable

class FaceView: UIView { //custom when nt using built in stuff

    @IBInspectable
    var scale: CGFloat = 0.9
    {
        didSet { //everytime scale changes
            //never call draw directly
            setNeedsDisplay() //need to be redisplay at "Earliest convenience" telling system
        }
    }
    
    @IBInspectable
    var eyesOpen: Bool = true
    {
        didSet {setNeedsDisplay()}
    }
    
    @IBInspectable
    var mouthCurvature: Double = 1.0 //1.0 full smile, -1.0 full frown
    {
        didSet {setNeedsDisplay()}
    }
  
    @IBInspectable
    var lineWidth: CGFloat = 5.0
    {
        didSet {setNeedsDisplay()}
    }
    
    @IBInspectable
    var color: UIColor = UIColor.black
    {
        didSet {setNeedsDisplay()}
    }
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state //inherits from UIGestureRecognizer
        {
            case.changed, .ended:
                scale *= pinchRecognizer.scale //adjust my scale by pinch recognizers scale
                pinchRecognizer.scale = 1 //reset scale everytime for incremental scale
                //print(scale)
                //scale changes but it doesnt redraw, func draw is the only way to draw
            default:
                break
        }
    }
    
    private var skullRadius: CGFloat { //computed vars, only getting
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
  
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
      // OR let skullCenter = convert(center, from: superview) //if not converted, in superview's coordinate system, not in mine
    
    private enum Eye {
        case left
        case right
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath
    {
        func centerOfEye(_ eye: Eye) -> CGPoint { //inside path for eye because not needed elsewhere
            let eyeOffset = skullRadius/Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 :1) * eyeOffset //adding or substracting eye offset depending on whether its lft or right, if its left its -1*eyeOffset else +1*eyeOffset
            return eyeCenter
        }
        
        let eyeRadius = skullRadius/Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        let path:UIBezierPath
        
        if eyesOpen {
        path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false) //can conditionally initialize
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x:eyeCenter.x-eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y)) //drawing a line
        }
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth / 2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        
        let path = UIBezierPath()
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1 ))) * mouthRect.height //the min max is to restrict range to 1 and -1
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset) //control points
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
        
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = lineWidth
        
        return path
    }
    
    
    
    private func pathForSkull() -> UIBezierPath
    {
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true) //all numbers have to be of type CGFloat, bezierpath dont need to get current path
        
        path.lineWidth = lineWidth
        return path
    }

    override func draw(_ rect: CGRect) {
        color.set() //both fill and stroke
        pathForSkull().stroke() //to actually draw
        pathForEye(.right).stroke()
        pathForEye(.left).stroke() //don't need to do Eye.right/Eye.left
        pathForMouth().stroke()
    }

    private struct Ratios {
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToEyeOffset: CGFloat = 3 //for all constants in struct
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthOffset: CGFloat = 3
    }
}
