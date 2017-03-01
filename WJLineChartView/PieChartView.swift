//
//  PieChartView.swift
//  WJLineChartView
//
//  Created by 汪俊 on 2017/2/23.
//  Copyright © 2017年 Codans. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    var viewWidth:CGFloat = 0                     // view的宽度
    var ViewHeight:CGFloat = 0                    // view的高度
    var centerPoint = CGPoint()                   // 圆的中心点
    var diameter:CGFloat = 0                      // 圆形的直径
    var anglesOfPie = [CGFloat]()                 // 角度
    var whiteLinePont = [CGPoint]()               // 白线在边上的点
    
    var keysStrings = [String]()                  // 展示文字数组
    var valueArray = [CGFloat]()                  // 展示的数据
    
    
 
    init(frame: CGRect, keys:[String]?, values:[CGFloat]) {
        super.init(frame: frame)
        if keys != nil {
            guard keys?.count == values.count else {
                self.backgroundColor = UIColor.red
                print("WJPieChartView:keys数量和values数量不一致！")
                return
            }
        }
        dealWithValues(frame: frame, keys: keys, values: values)
    }
    
    // MARK: - 数据处理
    func dealWithValues(frame: CGRect,keys:[String]?, values:[CGFloat]) {
        viewWidth = frame.size.width
        ViewHeight = frame.size.height
        centerPoint = CGPoint(x: viewWidth / 2, y: ViewHeight / 2)
        diameter = viewWidth < ViewHeight ? viewWidth : ViewHeight
        anglesOfPie = getPointsOfPie(array: getPointsOfCombination(array: values))
        whiteLinePont = getPointOfWhiteLines(angleArray: anglesOfPie)!
    }
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        for (index,angle) in anglesOfPie.enumerated() {
            if index == 0 {
                getPiedraw(tStartAngle:0, tEndAngle: angle, color: getRandomColor(alpha: 1.0))
            }else{
                getPiedraw(tStartAngle: anglesOfPie[index - 1], tEndAngle: angle, color: getRandomColor(alpha: 1.0))
            }
            
        }
        
        for Point in whiteLinePont {
            getLineDraw(startPont: centerPoint, endPoint: Point, color: UIColor.white)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 求数组元素各占元素和的百分比
    func getPointsOfCombination(array:[CGFloat]) -> [CGFloat] {
        var combination:CGFloat = 0
        var backArray = [CGFloat]()
        
        for num in array {
            combination += num
        }
        if combination != 0 {
            for num in array {
                let point = num / combination
                backArray.append(point)
            }
        }
        return backArray
    }
    

    // MARK: - 返回饼状图个模块分割的角度
    func getPointsOfPie(array:[CGFloat]) -> [CGFloat] {
        var backArray = [CGFloat]()
        var lastAngle:CGFloat = 0
        
        for num in array {
            let point = num * CGFloat(M_PI) * 2.0 + lastAngle
            lastAngle = point
            backArray.append(point)
        }
        return backArray
    }
    
    // MARK: - 获取分割线的边上的点
    func getPointOfWhiteLines(angleArray:[CGFloat]) -> [CGPoint]? {
        guard angleArray.count > 1 else {
            return nil
        }
        let r = diameter / 2.0
        var pointArray = [CGPoint]()
        for angle in angleArray {
            var point: CGPoint!
            let x = centerPoint.x + r * cos(angle)
            let y = centerPoint.y + r * sin(angle)
            point = CGPoint(x: x, y: y)
            pointArray.append(point)
        }
        return pointArray
    }
    
    // MARK: - 画圆
    func getPiedraw(tStartAngle:CGFloat, tEndAngle:CGFloat, color:UIColor) {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: viewWidth / 2, y: ViewHeight / 2), radius: diameter / 4, startAngle: tStartAngle, endAngle: tEndAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = diameter / 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapButt   // 对接截面
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
        
        addShapelayerAnamite(shapeLayer: shapeLayer, time: 1)
    }
    
    // MARK: - 划线
    func getLineDraw(startPont:CGPoint, endPoint:CGPoint, color:UIColor) {
        let path = UIBezierPath()
        path.move(to: startPont)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = diameter / 30.0
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapButt   // 对接截面
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 获取随机色
    func getRandomColor(alpha:CGFloat) -> UIColor {
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // MARK: - 添加划线动画 
    func addShapelayerAnamite(shapeLayer:CAShapeLayer, time:CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        shapeLayer.add(animation, forKey: "DonutScaleView")
    }
    

}
