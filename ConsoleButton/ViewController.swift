//
//  ViewController.swift
//  ConsoleButton
//
//  Created by Arturs Derkintis on 4/19/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grayColor()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Numbers
        let ap1 = Appearance(title : "0", imageNamed: nil, color: UIColor.blueColor())
        let ap2 = Appearance(title : "1", imageNamed: nil, color: UIColor.redColor())
        let ap3 = Appearance(title : "2", imageNamed: nil, color: UIColor.yellowColor())
        let ap4 = Appearance(title : "3", imageNamed: nil, color: UIColor.blueColor())
        let ap5 = Appearance(title : "4", imageNamed: nil, color: UIColor.orangeColor())
        let ap6 = Appearance(title : "5", imageNamed: nil, color: UIColor.cyanColor())
        let ap7 = Appearance(title : "6", imageNamed: nil, color: UIColor.brownColor())
        let ap8 = Appearance(title : "7", imageNamed: nil, color: UIColor.darkGrayColor())
        let consoleButton = ConsoleButton(appearances: ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8)
        consoleButton.frame = CGRect(x: 60, y: 60, width: 200, height: 200)
        consoleButton.addTarget(self, action: #selector(ViewController.consoleButtonTapped(_:)), forControlEvents: .TouchDown)
        consoleButton.layoutAppearance()
        view.addSubview(consoleButton)
        let app1 = Appearance(title : nil, imageNamed: "tool_1", color: UIColor.blueColor())
        let app2 = Appearance(title : nil, imageNamed: "tool_2", color: UIColor.redColor())
        let app3 = Appearance(title : nil, imageNamed: "tool_3", color: UIColor.magentaColor())
        let app4 = Appearance(title : nil, imageNamed: "tool_4", color: UIColor.blueColor())
        let app5 = Appearance(title : nil, imageNamed: "tool_5", color: UIColor.orangeColor())
        let consoleButton2 = ConsoleButton(appearances: app1, app2, app3, app4, app5)
        consoleButton2.frame = CGRect(x: 60, y: 300, width: 200, height: 200)
        consoleButton2.selectable = true
        consoleButton2.addTarget(self, action: #selector(ViewController.consoleButtonSelected(_:)), forControlEvents: .ValueChanged)
        consoleButton2.layoutAppearance()
        view.addSubview(consoleButton2)
    }
    
    func consoleButtonSelected(sender : ConsoleButton){
        print("Current selection \(sender.currentSelectedIndex)")
    }
    
    func consoleButtonTapped(sender : ConsoleButton){
        print("Current tap \(sender.currentSelectedIndex)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

