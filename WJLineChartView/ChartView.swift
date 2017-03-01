//
//  ChartView.swift
//  WJLineChartView
//
//  Created by 汪俊 on 2017/2/21.
//  Copyright © 2017年 Codans. All rights reserved.
//

import UIKit

let SCR_WIDTH = UIScreen.main.bounds.width
let SCR_HEIGHT = UIScreen.main.bounds.height

class ChartView: UIView {
    var x_axleStrings = [String]()
    var y_axleInts = [Int]()
    
    var viewWidth:CGFloat = 0                     // view的宽度
    var ViewHeight:CGFloat = 0                    // view的高度
    
    var originPoint = CGPoint()                   // 原点坐标
    
    var y_showInts:[Int]!                         // y轴显示的数值
    var linesStartPoints = [CGPoint]()            // 横线起点
    var linesEndPoints = [CGPoint]()              // 横线终点
    var linesDistance:CGFloat = 0                 // 横线的距离
    
    var xStringsDistance:CGFloat = 0              // x轴文字中点距离
    var xAxlePoints = [CGPoint]()                 // x轴上的文字坐标
    
    var brokenLinePoint = [CGPoint]()             // 折线的点
    
    typealias valueModel = [Int:Int]
    var chartValues = [valueModel]()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, keys:[String], values:[Int]) {
        super.init(frame: frame)
        guard keys.count == values.count else {
            self.backgroundColor = UIColor.red
            print("WJLineChartView:keys数量和values数量不一致！")
            return
        }
        x_axleStrings = keys
        y_axleInts = values
        viewWidth = frame.size.width
        ViewHeight = frame.size.height
        dealWithValues()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        // 画坐标轴
        let path = UIBezierPath()
        for i in 0...linesStartPoints.count - 1 {
            // x轴横线
            path.move(to: linesStartPoints[i])
            path.addLine(to: linesEndPoints[i])
//            drawText(string: NSString(string: y_showInts[i]) , x: linesStartPoints[i].x - 30, y: linesEndPoints[i].y - 8)
            addYTextLabels(string: "\(y_showInts[i])", centerPoint: linesStartPoints[i])
        }
        
        for i in 0...xAxlePoints.count - 1 {
            addXTextLabels(string: "\(x_axleStrings[i])", centerPoint: xAxlePoints[i])
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound   // 对接截面
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
        

        
        // 画折线
        let brokenPath = UIBezierPath()
        brokenPath.move(to: brokenLinePoint.first!)
        for point in brokenLinePoint {
            brokenPath.addLine(to: point)
        }
        let brokenShapeLayer = CAShapeLayer()
        brokenShapeLayer.strokeColor = UIColor(red: 0.973, green: 0.529, blue: 0.306, alpha: 1).cgColor
        brokenShapeLayer.fillColor = UIColor.clear.cgColor
        brokenShapeLayer.lineWidth = 3
        brokenShapeLayer.lineJoin = kCALineJoinRound
        brokenShapeLayer.lineCap = kCALineCapRound   // 对接截面
        brokenShapeLayer.path = brokenPath.cgPath
        self.layer.addSublayer(brokenShapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2.0
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        brokenShapeLayer.add(animation, forKey: "DonutScaleView")
    }
    
    /*
    // MARK: - 绘制文字
    func drawText(string:NSString, x:CGFloat, y:CGFloat) {
        string.draw(at: CGPoint(x: x, y: y), withAttributes: nil)
        
    }
    */
    // MARK: - 添加Ylabel
    func addYTextLabels(string:String , centerPoint:CGPoint) {
        let y_label = UILabel(frame: CGRect(x: 0, y: centerPoint.y, width: 30, height: 15))
        y_label.text = string
        y_label.font = UIFont.systemFont(ofSize: 10)
        y_label.textAlignment = .right
        y_label.center.y = centerPoint.y
        self.addSubview(y_label)
    }
    // MARK: - 添加Xlabel
    func addXTextLabels(string:String, centerPoint:CGPoint) {
        let x_label = UILabel(frame: CGRect(x: centerPoint.x, y: centerPoint.y + 5, width: xStringsDistance, height: 20))
        x_label.text = string
        x_label.font = UIFont.systemFont(ofSize: 10)
        x_label.textAlignment = .center
        x_label.center.x = centerPoint.x
        self.addSubview(x_label)
    }
    
    // 获取要画的横线的坐标
    func dealWithValues() {

        y_showInts = getShowYAxleInts(y_Values: y_axleInts)
        // 原点
        originPoint = CGPoint(x: 40, y: ViewHeight - 30)
        // 线的距离
        linesDistance = (originPoint.y) / CGFloat(y_showInts.count)
        // x坐标的距离
        xStringsDistance = (viewWidth - 20 - originPoint.x) / CGFloat(x_axleStrings.count - 1)
        // 获取横线的起点和终点集合
        for i in 0...y_showInts.count - 1 {
            linesStartPoints.append(CGPoint(x: originPoint.x, y: originPoint.y - linesDistance * CGFloat(i)))
            linesEndPoints.append(CGPoint(x: viewWidth - 20, y: originPoint.y - linesDistance * CGFloat(i)))
            
        }
        // 获取x轴上文字位置集合
        for i in 0...x_axleStrings.count - 1 {
            xAxlePoints.append(CGPoint(x: originPoint.x + xStringsDistance * CGFloat(i), y: originPoint.y))
        }
        // 获取折线的位置集合
        for (flag, _) in y_axleInts.enumerated() {
            let Px = xAxlePoints[flag].x
            let Py = originPoint.y - (CGFloat(y_axleInts[flag]) / CGFloat(y_showInts.last!)) * (originPoint.y - (linesStartPoints.last?.y)!)
            brokenLinePoint.append(CGPoint(x: Px, y: Py))
        }
        
    }
    
    // MARK: - 返回y轴显示的数值数组
    func getShowYAxleInts(y_Values:[Int]) -> [Int] {
        let maxNum = y_Values.max()!
        if maxNum <= 10 {
            // 0~10
            return[0, 2, 4, 6, 8, 10]
        }else if maxNum > 10 && maxNum <= 100{
            // 10~100
            return[0, 20, 40, 60, 80, 100]
        }else if maxNum > 100 && maxNum <= 500{
            // 100~500
            return [0, 100, 200, 300, 400, 500]
        }else if maxNum > 500 && maxNum <= 1000{
            // 500~1000
            return[0, 200, 400, 600, 800, 1000]
        }else if maxNum > 1000 && maxNum <= 2000{
            // 1000~2000
            return[0, 400, 800, 1200, 1600, 2000]
        }else if maxNum > 2000 && maxNum <= 3000{
            // 2000~3000
            return[0, 500, 1000, 1500, 2000, 2500, 3000]
        }
        // 超出3000
        var exceedArray = [0]
        for i in 1...(maxNum / 1000 + 1) {
            exceedArray.append(i * 1000)
        }
        return exceedArray
    }
    

}
