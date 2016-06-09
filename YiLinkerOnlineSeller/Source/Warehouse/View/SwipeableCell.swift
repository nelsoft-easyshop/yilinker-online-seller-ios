//
//  SwipeableCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 6/9/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit
import Foundation

class SwipeableCell: UITableViewCell, UIGestureRecognizerDelegate {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var warehouseName: UILabel!
    @IBOutlet weak var warehouseAddress: UILabel!
    
    @IBOutlet weak var containerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewRightConstraint: NSLayoutConstraint!
    
    var panRecognizer = UIPanGestureRecognizer()
    var startingRightLayoutConstraintConstant: CGFloat!
    var panStartPoint: CGPoint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: "panThisCell:")
        self.panRecognizer.delegate = self
        self.containerView.addGestureRecognizer(panRecognizer)
    }
    
    func panThisCell(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            
        case .Began:
            
            self.panStartPoint = recognizer.translationInView(self.containerView)
            self.startingRightLayoutConstraintConstant = self.containerViewRightConstraint.constant
            
            println("\(self.startingRightLayoutConstraintConstant)")
            println("\(self.containerViewRightConstraint)")
            break
            
        case .Changed:
            
            var currentPoint: CGPoint = recognizer.translationInView(self.containerView)
            var deltaX: CGFloat = currentPoint.x - self.panStartPoint.x
            var panningLeft: Bool = false
            if currentPoint.x < self.panStartPoint.x {
                //1
                panningLeft = true
            }
            if self.startingRightLayoutConstraintConstant == 0 {
                //2
                //The cell was closed and is now opening
                if !panningLeft {
                    var constant: CGFloat = max(-deltaX, 0)
                    //3
                    if constant == 0 {
                        //4
                        self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: false)
                        //5
                    }
                    else {
                        self.containerViewRightConstraint.constant = constant
                        //6
                    }
                }
                else {
                    var constant: CGFloat = min(-deltaX, self.buttonTotalWidth())
                    //7
                    if constant == self.buttonTotalWidth() {
                        //8
                        self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: false)
                        //9
                    }
                    else {
                        self.containerViewRightConstraint.constant = constant
                        //10
                    }
                }
            }
            else {
                //The cell was at least partially open.
                var adjustment: CGFloat = self.startingRightLayoutConstraintConstant - deltaX
                //11
                if !panningLeft {
                    var constant: CGFloat = max(adjustment, 0)
                    //12
                    if constant == 0 {
                        //13
                        self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: false)
                        //14
                    }
                    else {
                        self.containerViewRightConstraint.constant = constant
                        //15
                    }
                }
                else {
                    var constant: CGFloat = min(adjustment, self.buttonTotalWidth())
                    //16
                    if constant == self.buttonTotalWidth() {
                        //17
                        self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: false)
                        //18
                    }
                    else {
                        self.containerViewRightConstraint.constant = constant
                        //19
                    }
                }
            }
            self.containerViewLeftConstraint.constant = -self.containerViewRightConstraint.constant
            //20
            break
            
            
        case .Ended:
            
            if self.startingRightLayoutConstraintConstant == 0 {
                //1
                //We were opening
                var halfOfButtonOne: CGFloat = CGRectGetWidth(self.deleteButton.frame) / 2
                //2
                if self.containerViewRightConstraint.constant >= halfOfButtonOne {
                    //3
                    //Open all the way
                    self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
                }
                else {
                    //Re-close
                    self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: true)
                }
            }
            else {
                //We were closing
                var buttonOnePlusHalfOfButton2: CGFloat = CGRectGetWidth(self.deleteButton.frame) + (CGRectGetWidth(self.editButton.frame) / 2)
                //4
                if self.containerViewRightConstraint.constant >= buttonOnePlusHalfOfButton2 {
                    //5
                    //Re-open all the way
                    self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
                }
                else {
                    //Close
                    self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: true)
                }
            }
        case .Cancelled:
            if self.startingRightLayoutConstraintConstant == 0 {
                //We were closed - reset everything to 0
                self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: true)
            }
            else {
                //We were open - reset to the open state
                self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
            }
            break
            
        default:
            break
        }
        
    }
    
    func buttonTotalWidth() -> CGFloat {
        return CGRectGetWidth(self.frame) - CGRectGetMinX(self.editButton.frame)
    }
    
    func resetConstraintContstantsToZero(animated: Bool, notifyDelegateDidClose endEditing: Bool) {
        //TODO: Build.
    }
    
    func setConstraintsToShowAllButtons(animated: Bool, notifyDelegateDidOpen notifyDelegate: Bool) {
        //TODO: Build
    }

    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

