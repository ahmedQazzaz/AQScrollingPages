//
//  AQScrollingTabs.swift
//  ScrollingTabs
//
//  Created by Ahmed Qazzaz on 10/12/18.
//  Copyright © 2018 Ahmed Qazzaz. All rights reserved.
//

import UIKit

@IBDesignable class AQScrollingTabs: UIView {
    
    
    public var ViewControllers : [UIViewController] = []{
        didSet{
            
            for v in ViewControllers{
                if(v.title?.count == 0){
                    v.title = "Untitled"
                }
            }
            
        }
    }
    
    @IBInspectable var BarHeight : CGFloat = 64;
    @IBInspectable var IndicatorHeight : CGFloat = 2;
    @IBInspectable var BarBackground : UIColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    @IBInspectable var TabsBackground : UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    @IBInspectable var IndicatorColor : UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    @IBInspectable var textColor : UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    @IBInspectable var selectedColor : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    @IBInspectable var IsTop : Bool = true
    
    @IBInspectable var FontName : String?
    @IBInspectable var FontSize : CGFloat = 14
    
    @IBOutlet var containerViewController : UIViewController!
    
    
    @IBInspectable var Dummy : Int = 3
    
    var currentIndex : Int = 0
    @IBInspectable var startIndex : Int = 0 {
        didSet{
            self.currentIndex = startIndex
        }
    }
    
    
    struct Dragging {
        var start : CGFloat = 0.0
        var current : CGFloat = 0.0
        var originalPage : Int = 0
        var newPage : Int = 0
    }
    
    private var draggingOptions = Dragging()
    
    
    private var dummyColors = [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)]
    private var Bar : UIScrollView = UIScrollView.init()
    private var Tabs : UIScrollView = UIScrollView.init(frame: CGRect.zero)
    private var selectionIndicator : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private var didDraw : Bool = false
    private var barInternalView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    
    private var tabsInternalView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    private var tabsInternalStack : UIStackView = UIStackView.init()
    
    private var barInternalStack : UIStackView = UIStackView.init()
    private var TabButtons : [UIButton] = []
    private var TabViewControllers : [UIViewController] = []
    private var maxWidth : CGFloat = 0;
    
    private var isDragging = 0
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    
    private func createTopScrollingBar(){
        
    }
    
    @objc private func orientationDidChange(){
        if(self.TabButtons.count == 0){
            return
        }
        
        self.updateConstraints()
        self.layoutIfNeeded()
        
        maxWidth = 0;
        
        for btn in self.TabButtons {
            
            if(maxWidth == 0){
                maxWidth = btn.frame.width
            }
            
            maxWidth = min(maxWidth, btn.frame.width)
        }
        
        
        self.layoutElements()
        self.updateSelection(animated: false)
        self.scrollToIndex()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if(self.didDraw == false){
            self.didDraw = true;
            
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
            
            
            Bar.translatesAutoresizingMaskIntoConstraints = false
            self.barInternalView.translatesAutoresizingMaskIntoConstraints = false
            self.barInternalStack.translatesAutoresizingMaskIntoConstraints = false
            self.Tabs.translatesAutoresizingMaskIntoConstraints = false
            self.tabsInternalView.translatesAutoresizingMaskIntoConstraints = false
            self.tabsInternalStack.translatesAutoresizingMaskIntoConstraints = false

            
            self.addSubview(Bar)
            
            
            if(self.IsTop){
                
            self.addConstraint(NSLayoutConstraint.init(item: self.Bar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
            }else{
                self.addConstraint(NSLayoutConstraint.init(item: self.Bar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
            }
            
            self.addConstraint(NSLayoutConstraint.init(item: self.Bar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.Bar, attribute: .trailing, multiplier: 1, constant: 0))
            
            
            self.Bar.addConstraint(NSLayoutConstraint.init(item: self.Bar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(self.BarHeight)))
            
            self.Bar.backgroundColor = self.BarBackground
            self.barInternalView.backgroundColor = self.BarBackground
            
            self.Bar.addSubview(self.barInternalView)
            
            self.Bar.addConstraint(NSLayoutConstraint.init(item: self.barInternalView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self.Bar, attribute: .width, multiplier: 1, constant: 0))
            
            self.Bar.addConstraint(NSLayoutConstraint.init(item: self.barInternalView, attribute: .leading, relatedBy: .equal, toItem: self.Bar, attribute: .leading, multiplier: 1, constant: 0))
            
            self.Bar.addConstraint(NSLayoutConstraint.init(item: self.Bar, attribute: .trailing, relatedBy: .equal, toItem: self.barInternalView, attribute: .trailing, multiplier: 1, constant: 0))
            
           
            self.Bar.addConstraint(NSLayoutConstraint.init(item: self.barInternalView, attribute: .top, relatedBy: .equal, toItem: self.Bar, attribute: .top, multiplier: 1, constant: 0))
            
            self.Bar.addConstraint(NSLayoutConstraint.init(item: self.Bar, attribute: .bottom, relatedBy: .equal, toItem: self.barInternalView, attribute: .bottom, multiplier: 1, constant: 0))
           

            self.Bar.addConstraint(NSLayoutConstraint.init(item: self.barInternalView, attribute: .centerY, relatedBy: .equal, toItem: self.Bar, attribute: .centerY, multiplier: 1, constant: 0))
            


            self.barInternalView.addSubview(self.barInternalStack)

            self.barInternalStack.alignment = .fill
            self.barInternalStack.axis = .horizontal
            self.barInternalStack.spacing = 20;
            self.barInternalStack.distribution = .fillEqually

            self.barInternalView.addConstraint(NSLayoutConstraint.init(item: self.barInternalStack, attribute: .top, relatedBy: .equal, toItem: self.barInternalView, attribute: .top, multiplier: 1, constant: 0))
            self.barInternalView.addConstraint(NSLayoutConstraint.init(item: self.barInternalView, attribute: .bottom, relatedBy: .equal, toItem: self.barInternalStack, attribute: .bottom, multiplier: 1, constant: 0))

            self.barInternalView.addConstraint(NSLayoutConstraint.init(item: self.barInternalStack, attribute: .leading, relatedBy: .equal, toItem: self.barInternalView, attribute: .leading, multiplier: 1, constant: 20))

            self.barInternalView.addConstraint(NSLayoutConstraint.init(item: self.barInternalView, attribute: .trailing, relatedBy: .equal, toItem: self.barInternalStack, attribute: .trailing, multiplier: 1, constant: 20))
            
            self.selectionIndicator.frame = CGRect(x: 0, y: self.BarHeight - self.IndicatorHeight - 2, width: 100, height: self.IndicatorHeight)
            self.selectionIndicator.backgroundColor = self.IndicatorColor
            
            
            self.Tabs.backgroundColor = self.TabsBackground;
            self.Tabs.isPagingEnabled = true
            self.Tabs.showsHorizontalScrollIndicator = false;
            self.Tabs.showsVerticalScrollIndicator = false;
            
            self.Bar.showsHorizontalScrollIndicator = false;
            self.Bar.showsVerticalScrollIndicator = false;
            
            self.Tabs.delegate = self;
            
            self.superview?.addSubview(Tabs)
             if(self.IsTop){
            self.superview?.addConstraint(NSLayoutConstraint.init(item: self.Tabs, attribute: .top, relatedBy: .equal, toItem: self.Bar, attribute: .bottom, multiplier: 1, constant: 0))
            
            self.superview?.addConstraint(NSLayoutConstraint.init(item: self.Tabs, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
             }else{
                
                self.superview?.addConstraint(NSLayoutConstraint.init(item: self.Tabs, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
                
                self.superview?.addConstraint(NSLayoutConstraint.init(item: self.Tabs, attribute: .bottom, relatedBy: .equal, toItem: self.Bar, attribute: .top, multiplier: 1, constant: 0))
            }
            self.superview?.addConstraint(NSLayoutConstraint.init(item: self.Tabs, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
            
            self.superview?.addConstraint(NSLayoutConstraint.init(item: self.Tabs, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
            
            
            self.tabsInternalView.backgroundColor = self.TabsBackground
            
            self.Tabs.addSubview(self.tabsInternalView)
            
            self.Tabs.addConstraint(NSLayoutConstraint.init(item: self.tabsInternalView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self.Tabs, attribute: .width, multiplier: 1, constant: 0))
            
            self.Tabs.addConstraint(NSLayoutConstraint.init(item: self.tabsInternalView, attribute: .leading, relatedBy: .equal, toItem: self.Tabs, attribute: .leading, multiplier: 1, constant: 0))
            
            self.Tabs.addConstraint(NSLayoutConstraint.init(item: self.Tabs, attribute: .trailing, relatedBy: .equal, toItem: self.tabsInternalView, attribute: .trailing, multiplier: 1, constant: 0))
            self.Tabs.addConstraint(NSLayoutConstraint.init(item: self.tabsInternalView, attribute: .top, relatedBy: .equal, toItem: self.Tabs, attribute: .top, multiplier: 1, constant: 0))
            self.Tabs.addConstraint(NSLayoutConstraint.init(item: self.Tabs, attribute: .bottom, relatedBy: .equal, toItem: self.tabsInternalView, attribute: .bottom, multiplier: 1, constant: 0))
            
            self.Tabs.addConstraint(NSLayoutConstraint.init(item: self.tabsInternalView, attribute: .centerY, relatedBy: .equal, toItem: self.Tabs, attribute: .centerY, multiplier: 1, constant: 0))
            
            self.tabsInternalView.addSubview(self.tabsInternalStack)
            
            self.tabsInternalStack.alignment = .fill
            self.tabsInternalStack.axis = .horizontal
            self.tabsInternalStack.spacing = 0;
            self.tabsInternalStack.distribution = .equalSpacing
            
            self.tabsInternalView.addConstraint(NSLayoutConstraint.init(item: self.tabsInternalStack, attribute: .top, relatedBy: .equal, toItem: self.tabsInternalView, attribute: .top, multiplier: 1, constant: 0))
            self.tabsInternalView.addConstraint(NSLayoutConstraint.init(item: self.tabsInternalView, attribute: .bottom, relatedBy: .equal, toItem: self.tabsInternalStack, attribute: .bottom, multiplier: 1, constant: 0))
            
            self.tabsInternalView.addConstraint(NSLayoutConstraint.init(item: self.tabsInternalStack, attribute: .leading, relatedBy: .equal, toItem: self.tabsInternalView, attribute: .leading, multiplier: 1, constant: 0))
            
            self.tabsInternalView.addConstraint(NSLayoutConstraint.init(item: self.tabsInternalView, attribute: .trailing, relatedBy: .equal, toItem: self.tabsInternalStack, attribute: .trailing, multiplier: 1, constant: 0))
            
            
            
            
            
            
            #if !TARGET_INTERFACE_BUILDER
                self.fillReal()
            #else
                self.fillDummy()
            #endif

            if(self.TabButtons.count > 0){
                self.barInternalStack.addSubview(selectionIndicator)
            }
           self.layoutElements()
            
            
        }
        
    }
    
    private func layoutElements(){
        if(self.TabButtons.count == 0){
            return
        }
        
        
        self.barInternalView.layoutIfNeeded()
        self.Bar.layoutIfNeeded()
        self.layoutIfNeeded()
        
        self.tabsInternalView.layoutIfNeeded()
        self.tabsInternalStack.layoutIfNeeded()
        self.Tabs.layoutIfNeeded()
        self.layoutIfNeeded()
        
        if(self.getCurrentLanguageDirection() == .RTL){
            if let lastBtn = self.TabButtons.last{
                let visibleButtons = Int(UIScreen.main.bounds.width / self.maxWidth) / 2
                self.Bar.contentOffset = CGPoint(x: lastBtn.frame.width * CGFloat(lastBtn.tag - visibleButtons), y: 0)
            }
        }
        
        if(self.getCurrentLanguageDirection() == .RTL){
            if let lastView = self.TabViewControllers.last{
                self.Tabs.contentOffset = CGPoint(x: self.frame.width * CGFloat(lastView.view.tag), y: 0)
            }
        }
        
        var startPoint :CGFloat = 0;
        if(self.currentIndex < self.TabButtons.count){
            startPoint = self.TabButtons[currentIndex].frame.origin.x
        }
        self.selectionIndicator.frame.size.width = maxWidth
        self.selectionIndicator.frame.origin.x = startPoint
        
        if(self.currentIndex >= 0 && self.currentIndex < self.TabButtons.count){
            let vc = self.TabViewControllers[self.currentIndex]
            self.Tabs.scrollRectToVisible(vc.view.frame, animated: false)
        }
        
    }
    
    private func updateButtons(){
        for btn in TabButtons {
            if(self.currentIndex == btn.tag){
                btn.setTitleColor(self.selectedColor, for: .normal)
            }else{
                btn.setTitleColor(self.textColor, for: .normal)
            }
        }
    }
    
    
    private func updateSelection(animated : Bool){
        
        if(self.TabButtons.count == 0){
            return
        }
        
        if(self.currentIndex < 0){
            self.currentIndex = draggingOptions.originalPage
        }
        var startPoint :CGFloat = 0;
        if(self.currentIndex < self.TabButtons.count){
            startPoint = self.TabButtons[currentIndex].frame.origin.x
        }
        
        let ratio = self.selectionIndicator.frame.width / self.TabViewControllers.first!.view.frame.width
        let actualValue = ratio * self.draggingOptions.current * CGFloat(self.isDragging)
        
        
        UIView.animate(withDuration: 0.245) {
            self.selectionIndicator.frame.origin.x = (startPoint - actualValue)
        }
        var f = self.TabButtons[currentIndex].frame
        f.size.width = f.size.width + (f.width / 3.0) + actualValue
        self.Bar.scrollRectToVisible(f, animated: true)
        self.updateButtons()
        
    }
    
    @objc private func didSelectTab(sender : UIButton){
        self.currentIndex = sender.tag
        self.updateButtons()
        self.updateSelection(animated: true)
        self.scrollToIndex()
    }
    
    private func scrollToIndex(){
        let vc = self.TabViewControllers[self.currentIndex]
        self.Tabs.scrollRectToVisible(vc.view.frame, animated: true)
    }
    

}


enum LanguageDirection {
    case LTR
    case RTL
}

extension AQScrollingTabs {
    
    
    func fillReal(){
        
        for vc in self.ViewControllers{
            
            let btn = UIButton.init()
            btn.setTitle(vc.title ?? "???", for: .normal)
            btn.setTitleColor(self.textColor, for: .normal)
            self.barInternalStack.addArrangedSubview(btn)
            btn.tag = self.TabButtons.count
            btn.addTarget(self, action: #selector(didSelectTab(sender:)), for: .touchUpInside)
            self.TabButtons.append(btn)
            
            if let font = UIFont.init(name: self.FontName ?? "", size: FontSize){
                btn.titleLabel?.font = font
            }else{
                btn.titleLabel?.font = UIFont.systemFont(ofSize: FontSize)
            }
            
            
            //btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5210167254)
            
            self.barInternalStack.layoutIfNeeded()
            btn.layoutIfNeeded()
            if(maxWidth == 0){
                maxWidth = btn.frame.width
            }
            maxWidth = min(maxWidth, btn.frame.width)
            
            self.tabsInternalStack.addArrangedSubview(vc.view)
            vc.view.tag = self.TabViewControllers.count
            
            if(currentIndex == btn.tag){
                btn.setTitleColor(self.selectedColor, for: .normal)
            }
            
            
            if (self.TabViewControllers.count == 0){
                
                self.Tabs.addConstraint(NSLayoutConstraint.init(item: vc.view, attribute: .height, relatedBy: .equal, toItem: self.Tabs, attribute: .height, multiplier: 1, constant: 0))
                
                self.superview?.addConstraint(NSLayoutConstraint.init(item: vc.view, attribute: .width, relatedBy: .equal, toItem: self.superview, attribute: .width, multiplier: 1, constant: 0))
                
            }else{
                let first = self.TabViewControllers.first!
                
                self.tabsInternalStack.addConstraint(NSLayoutConstraint.init(item: vc.view, attribute: .width, relatedBy: .equal, toItem: first.view, attribute: .width, multiplier: 1, constant: 0))
                
                self.tabsInternalStack.addConstraint(NSLayoutConstraint.init(item: vc.view, attribute: .height, relatedBy: .equal, toItem: first.view, attribute: .height, multiplier: 1, constant: 0))
            }
            
            if(self.containerViewController != nil){
                vc.RootViewController = self.containerViewController                                
            }
            
            self.TabViewControllers.append(vc)            
        }
    }
        
    
    func fillDummy(){
        
        for i in 0 ..< Dummy{
            let btn = UIButton.init()
            btn.setTitle("Dummy_\(i)", for: .normal)
            btn.setTitleColor(self.textColor, for: .normal)
        
            self.barInternalStack.addArrangedSubview(btn)
            
            btn.tag = self.TabButtons.count
            btn.addTarget(self, action: #selector(didSelectTab(sender:)), for: .touchUpInside)
            self.TabButtons.append(btn)
            
            
            if let font = UIFont.init(name: self.FontName ?? "", size: FontSize){
                btn.titleLabel?.font = font
            }else{
                btn.titleLabel?.font = UIFont.systemFont(ofSize: FontSize)
            }
            
            self.barInternalStack.layoutIfNeeded()
            btn.layoutIfNeeded()            
            if(maxWidth == 0){
                maxWidth = btn.frame.width
            }
            maxWidth = min(maxWidth, btn.frame.width)
            
            if(currentIndex == btn.tag){
                btn.setTitleColor(self.selectedColor, for: .normal)
            }
            
            
            let dummy_vc = UIViewController.init()
            
            dummy_vc.view.backgroundColor = dummyColors[self.TabViewControllers.count % dummyColors.count]
            

            self.tabsInternalStack.addArrangedSubview(dummy_vc.view)
            dummy_vc.view.tag = self.TabViewControllers.count
            
            
            if (self.TabViewControllers.count == 0){
               
                self.Tabs.addConstraint(NSLayoutConstraint.init(item: dummy_vc.view, attribute: .height, relatedBy: .equal, toItem: self.Tabs, attribute: .height, multiplier: 1, constant: 0))
                
                self.superview?.addConstraint(NSLayoutConstraint.init(item: dummy_vc.view, attribute: .width, relatedBy: .equal, toItem: self.superview, attribute: .width, multiplier: 1, constant: 0))
                
            }else{
                let first = self.TabViewControllers.first!
                
                self.tabsInternalStack.addConstraint(NSLayoutConstraint.init(item: dummy_vc.view, attribute: .width, relatedBy: .equal, toItem: first.view, attribute: .width, multiplier: 1, constant: 0))
                
                self.tabsInternalStack.addConstraint(NSLayoutConstraint.init(item: dummy_vc.view, attribute: .height, relatedBy: .equal, toItem: first.view, attribute: .height, multiplier: 1, constant: 0))                
            }
            
            self.TabViewControllers.append(dummy_vc)
            
        }
        
        
        

    }
    
    
    
    
    
    
    func getCurrentLanguageDirection()->LanguageDirection{
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            
         return .RTL
        }
        
        return .LTR
    }
    
}

extension AQScrollingTabs : UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("WillBegin")
        self.isDragging = 1
        draggingOptions.start = scrollView.contentOffset.x
        draggingOptions.originalPage = self.currentIndex
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isDragging = 0
        

        self.currentIndex = self.currentIndex + draggingOptions.newPage
        
        self.updateSelection(animated: true)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        draggingOptions.current = draggingOptions.start - scrollView.contentOffset.x
        
        if(draggingOptions.current < 0){
            print("Going Next")
            draggingOptions.newPage = 1
            
            if(getCurrentLanguageDirection() == .RTL){
                draggingOptions.newPage = -1
            }
            
        }else if (draggingOptions.current > 0){
            print("Going Previous")
            
            draggingOptions.newPage = -1
            
            if(getCurrentLanguageDirection() == .RTL){
                draggingOptions.newPage = 1
            }
            
        }else{
            draggingOptions.newPage = 0
        }
        
        self.updateSelection(animated: true)
    }
}

fileprivate struct AQScrollingTabsKeys {
    static var rootViewController : UInt8 = 1
}

extension UIViewController {
    
    var RootViewController : UIViewController?{
        set(value){
            objc_setAssociatedObject(self, &AQScrollingTabsKeys.rootViewController, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get{
            return objc_getAssociatedObject(self, &AQScrollingTabsKeys.rootViewController) as? UIViewController
        }
    }
    
}
