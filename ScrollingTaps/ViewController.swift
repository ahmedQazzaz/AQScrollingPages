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
        
        let vc1 = UIViewController.init()
        vc1.view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        vc1.title = NSLocalizedString("Hello World", comment: "")
        
        let vc2 = UIViewController.init()
        vc2.view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        vc2.title = NSLocalizedString("Great View", comment: "")
        
        let vc3 = UIViewController.init()
        vc3.view.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        vc3.title = NSLocalizedString("OMG", comment: "")
        
        let vc4 = UIViewController.init()
        vc4.view.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        vc4.title = NSLocalizedString("SHIT", comment: "")
        
        let vc5 = UIViewController.init()
        vc5.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        vc5.title = NSLocalizedString("Opps", comment: "")
        
  

        
        pager.ViewControllers = [vc1, vc2, vc3, vc4, vc5]
        
        
    }


}

