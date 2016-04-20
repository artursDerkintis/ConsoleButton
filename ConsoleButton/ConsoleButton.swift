//
//  ConsoleButton.swift
//  ConsoleButton
//
//  Created by Arturs Derkintis on 4/19/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

struct Appearance {
    var title   : String?
    var imageNamed : String?
    var color   : UIColor = UIColor.blueColor()
    func image() -> UIImage?{
        if let imageNamed = self.imageNamed{
            return UIImage(named: imageNamed)
        }
        return nil
    }
}

class ConsoleButton: UIControl {
    let centerColor = UIColor.greenColor()
    var appearances = [Appearance]()
    var buttons = [UIButton]()
    var layers = [CAShapeLayer]()
    var touchedLayer : CAShapeLayer?
    var originalColor = UIColor.blueColor().CGColor
    var currentSelectedIndex : Int = 0
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience init(appearances : Appearance...){
        self.init()
        self.appearances = appearances
        
    }
    
    var selectable = false
    
    func layoutAppearance(){
        
        let centerLayer = CALayer()
        centerLayer.frame = CGRect(x: frame.width * 0.25, y: frame.width * 0.25, width: frame.width * 0.5, height: frame.height * 0.5)
        centerLayer.backgroundColor = centerColor.CGColor
        centerLayer.cornerRadius = frame.width * 0.25
        centerLayer.masksToBounds = true
        layer.addSublayer(centerLayer)
        
        let origin = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let radius = frame.width * 0.37
        let averageAngle = CGFloat(2 * M_PI) / CGFloat(appearances.count)
        for (idx, appearance) in appearances.enumerate(){
            let x = origin.x + radius * cos(averageAngle * CGFloat(idx))
            let y = origin.y + radius * sin(averageAngle * CGFloat(idx))
            let newOrigin = CGPoint(x: x, y: y)
            
            let start = ((averageAngle * CGFloat(idx)) - (averageAngle * 0.5))
            let end = ((averageAngle * CGFloat(idx)) + (averageAngle * 0.5))

            let newPath = UIBezierPath(arcCenter: origin, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            let newLayer = CAShapeLayer()
            newLayer.frame = bounds
            newLayer.path = newPath.CGPath
            newLayer.lineWidth = frame.width * 0.25
            newLayer.strokeColor = appearance.color.CGColor
            newLayer.fillColor = UIColor.clearColor().CGColor
            layers.append(newLayer)
            layer.addSublayer(newLayer)
            
            let button = UIButton(type: .Custom)
            if let title = appearance.title{
                button.setTitle(title, forState: .Normal)
                button.setTitleColor(.whiteColor(), forState: .Normal)
                button.setTitleColor(.blackColor(), forState: .Highlighted)
                button.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
                button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 1)
                button.titleLabel?.layer.shadowRadius = 1
                button.titleLabel?.layer.shadowOpacity = 0.4
            }else if let icon = appearance.image(){
                button.setImage(icon, forState: .Normal)
                button.setImage(icon.imageWithColor(UIColor.lightGrayColor()), forState: .Selected)
            }
            
            button.frame = CGRect(x: 0, y: 0, width: frame.width * 0.12, height: frame.height * 0.12)
            button.userInteractionEnabled = false
            button.center = newOrigin
            button.tag = idx
            buttons.append(button)
            addSubview(button)
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            
            let location = touch.locationInView(self)
            
            for (idx, layer) in layers.enumerate(){
                
                let strokedPath = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, CGLineCap.Butt, CGLineJoin.Round, 0);
                
                if(CGPathContainsPoint(strokedPath, nil, location, true)){
                    
                    self.currentSelectedIndex = idx
                    self.sendActionsForControlEvents(.TouchDown)
                    buttons[idx].highlighted = true
                    
                    if selectable{
                        self.sendActionsForControlEvents(.ValueChanged)
                        if let layer = touchedLayer {
                            touchUp(layer)
                            touchedLayer = nil
                        }
                        for button in buttons{
                            button.selected = false
                        }
                        buttons[idx].selected = true
                    }
                    touchedLayer = layer
                    touchDown(layer)
                    buttons[idx].highlighted = false
                    break
                    
                }
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.sendActionsForControlEvents([.TouchUpOutside, .TouchUpInside])

        if selectable{
            return
        }
        if let layer = touchedLayer {
            touchUp(layer)
            touchedLayer = nil
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ConsoleButton{
    
    func touchDown(layer : CAShapeLayer){
        layer.removeAllAnimations()
        let faded = CABasicAnimation(keyPath: "strokeColor")
        originalColor = layer.strokeColor ?? UIColor.blueColor().CGColor
        faded.fromValue = originalColor
        faded.toValue = UIColor(CGColor: originalColor).mixWithColor(UIColor.blackColor(), amount: 0.3).CGColor
        faded.duration = 0.1
        faded.autoreverses = false
        faded.removedOnCompletion = false
        faded.fillMode = kCAFillModeForwards
        layer.addAnimation(faded, forKey: "opacity")
    }
    
    func touchUp(layer : CAShapeLayer){
        layer.removeAllAnimations()
        let faded = CABasicAnimation(keyPath: "strokeColor")
        faded.fromValue = layer.strokeColor
        faded.toValue = originalColor
        faded.duration = 0.1
        faded.autoreverses = false
        faded.removedOnCompletion = false
        faded.fillMode = kCAFillModeForwards
        layer.addAnimation(faded, forKey: "opacity")
    }
    
}
extension UIColor {
    
    func mixLighter (amount: CGFloat = 0.25) -> UIColor {
        return mixWithColor(UIColor.whiteColor(), amount:amount)
    }
    
    func mixDarker (amount: CGFloat = 0.25) -> UIColor {
        return mixWithColor(UIColor.blackColor(), amount:amount)
    }
    
    func mixWithColor(color: UIColor, amount: CGFloat = 0.25) -> UIColor {
        var r1     : CGFloat = 0
        var g1     : CGFloat = 0
        var b1     : CGFloat = 0
        var alpha1 : CGFloat = 0
        var r2     : CGFloat = 0
        var g2     : CGFloat = 0
        var b2     : CGFloat = 0
        var alpha2 : CGFloat = 0
        
        self.getRed (&r1, green: &g1, blue: &b1, alpha: &alpha1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &alpha2)
        return UIColor( red:r1*(1.0-amount)+r2*amount,
                        green:g1*(1.0-amount)+g2*amount,
                        blue:b1*(1.0-amount)+b2*amount,
                        alpha: alpha1 )
    }
}
extension UIImage {
    
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef!
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
public extension Int {
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
public extension CGFloat {
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}