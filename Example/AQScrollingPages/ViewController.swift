//
//  ViewController.swift
//  ScrollingTaps
//
//  Created by Ahmed Qazzaz on 10/12/18.
//  Copyright © 2018 Ahmed Qazzaz. All rights reserved.
//

import UIKit

@IBDesignable class ViewController: UIViewController {
    
    @IBOutlet var pager : AQScrollingTabs!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "basicViewController") as! UIViewController
        vc1.view.backgroundColor = UIColor.red
        vc1.title = NSLocalizedString("Hello World", comment: "")
        
        let vc2 = UIViewController.init()
        vc2.view.backgroundColor = UIColor.green
        vc2.title = NSLocalizedString("Second View", comment: "")
        
        let vc3 = UIViewController.init()
        vc3.view.backgroundColor = UIColor.blue
        
        vc3.title = NSLocalizedString("Third", comment: "")
        
        let vc4 = UIViewController.init()
        vc4.view.backgroundColor = UIColor.black
        vc4.title = NSLocalizedString("Fourth", comment: "")
        
        let vc5 = UIViewController.init()
        vc5.view.backgroundColor = UIColor.orange
        vc5.title = NSLocalizedString("Last", comment: "")
        
        pager.ViewControllers = [vc1, vc2, vc3, vc4, vc5]
        
    }
    
    
}

