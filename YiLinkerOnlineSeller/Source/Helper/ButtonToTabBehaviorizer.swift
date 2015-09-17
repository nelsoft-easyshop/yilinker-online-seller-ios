//
//  ButtonToTabBehaviorizer.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 8/31/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

enum ButtonChoice {
    case TabOne
    case TabTwo
    case TabThree
}

class ButtonToTabBehaviorizer  {
    private weak var tabOne : UIButton!
    private weak var tabTwo : UIButton!
    private weak var tabTre : UIButton!
    private weak var selectedTab : UIButton!
    private var selectedColor : UIColor = UIColor.whiteColor()
    private var unselectedColor : UIColor = UIColor.purpleColor()

    func viewDidLoadInitialize( first: UIButton!, second: UIButton!, third: UIButton! )
    {
        self.tabOne = first
        self.tabTwo = second
        self.tabTre = third
        self.selectedTab = self.tabOne
        self.selectedColor = self.selectedTab.backgroundColor!
        self.unselectedColor = self.tabTwo.backgroundColor!
    }
    
    func didSelectTheSameTab(currentSelection: AnyObject) -> Bool {
        return (currentSelection as! UIButton) == self.selectedTab
    }
    
    func setSelection(selection: ButtonChoice)
    {
        var selectedButtonTab : UIButton
        var selectedButtonImage : String = ""

        switch selection {
        case .TabOne:
            selectedButtonTab = self.tabOne!
            selectedButtonImage = "tab0-cases-p"
        case .TabTwo:
            selectedButtonTab = self.tabTwo!
            selectedButtonImage = "tab1-open-p"
        case .TabThree:
            selectedButtonTab = self.tabTre!
            selectedButtonImage = "tab2-close-p"
        }
        
        self.setSelectedButtonColor( selectedButtonTab )
        self.deselectAllTabs()
        self.setSelectedTabImage( selectedButtonImage )
    }
    
    private func setSelectedButtonColor(sender: UIButton!) {
        sender.backgroundColor = self.selectedColor
        self.selectedTab.backgroundColor = self.unselectedColor
        self.selectedTab = sender
    }
    
    private func deselectAllTabs() {
        self.tabOne!.setImage(UIImage(named: "tab0-cases-w"), forState: .Normal)
        self.tabTwo!.setImage(UIImage(named: "tab1-open-w"),  forState: .Normal)
        self.tabTre!.setImage(UIImage(named: "tab2-close-w"), forState: .Normal)
    }
    
    private func setSelectedTabImage(imageName : String) {
        self.selectedTab.setImage(UIImage(named: imageName), forState: .Normal)
    }

}