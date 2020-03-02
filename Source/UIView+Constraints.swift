//
//  UIView+Constraints.swift
//  KeyboardControll
//
//  Created by Ruslan Akhriev on 02.03.2020.
//

import Foundation

internal extension UIView {
    
    func appendConstraints(to view: UIView, withSafeArea isWithSafeArea: Bool = false) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if isWithSafeArea, #available(iOS 11.0, *) {
            
            view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
        } else {
            
            view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
    }
    
    func setConstraint(type: NSLayoutConstraint.Attribute, value: CGFloat, updateSuperview: Bool = true) {
        
        if let constraint = findConstraint(type: type) {
            
            constraint.constant = value
            
        } else {
            
            switch type {
                
            case .width  : widthAnchor.constraint(equalToConstant  : value)
            case .height : heightAnchor.constraint(equalToConstant : value)
            default      : break
            }
        }
        
        if updateSuperview {
            
            superview?.layoutIfNeeded()
        } else {
            layoutIfNeeded()
        }
    }
    
    func findConstraint(type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        
        if let constraint = findConstraintInSuperview(type: type) {
            
            return constraint
        }
        
        for constraint in constraints {
            
            if constraint.firstAttribute == type && constraint.secondAttribute != type {
                
                return constraint
            }
        }
        
        return nil
    }
    
     func findConstraintInSuperview(type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
         
         if let superview = superview {
             
             for constraint in superview.constraints {
                 
                 let isFirstItemIsSelf = (constraint.firstItem as? UIView) == self
                 
                 let isSecondItemIsSelf = (constraint.secondItem as? UIView) == self
                 
                 let isConstraintAssociatedWithSelf = (isFirstItemIsSelf || isSecondItemIsSelf)
                 
                 if constraint.firstAttribute == type && isConstraintAssociatedWithSelf {
                     
                     return constraint
                 }
             }
         }
         
         return nil
     }
    
    func hasScroll() -> Bool {
        
        return self.subviews.compactMap{$0 as? UIScrollView}.count == 0 ? false : true
    }
}
