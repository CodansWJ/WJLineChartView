//
//  ViewController.swift
//  WJLineChartView
//
//  Created by 汪俊 on 2017/2/21.
//  Copyright © 2017年 Codans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var chartView:ChartView!
    var pieChartView: PieChartView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        // 添加折线图
        chartView = ChartView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.6), keys: ["4月26日", "", "4月28日", "", "4月30日", "", "5月2日", ""], values: [5, 25, 20, 45, 60, 40, 35, 10])
        chartView.backgroundColor = UIColor.white
        self.view.addSubview(chartView)
        // 添加饼状图
        pieChartView = PieChartView(frame: CGRect(x: 0, y: 400, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.6), keys: nil, values: [6, 15.3, 11.9, 20, 10])
        pieChartView.backgroundColor = UIColor.white
        self.view.addSubview(pieChartView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

