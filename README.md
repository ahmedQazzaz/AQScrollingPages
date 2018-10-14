# AQScrollingPages

## About AQScrollingPages

AQScrollingPages is an easy component for iOS to integrate in your project, you can make pages with a scrolling tab bar, or without tab bar, in a few lettle steps.

Support   IBDesignable
Langugae  swift 4
Support   LTR and RTL languages

## Storyboard Customization
![Storyboatd Customization](http://aaqsoftwarecom.ipage.com/storyboardCustomization.png)

## Example
```swift
      let vc1 = UIViewController.init()
        vc2.view.backgroundColor = UIColor.green
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
```

In your project you may create your view controller from the storyboard
```swift
let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "BasicViewController") as! BasicViewController
```

## Author

Ahmed Qazzaz, aqazzaz2@hotmail.com


