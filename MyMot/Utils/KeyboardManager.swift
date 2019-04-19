//
//  KeyboardManager.swift
//  MyMot
//
//  Created by Michail Solyanic on 19/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

protocol KeyboardEventsDelegate {
    var hideKeyboardByTouchView: UIView? { get }
    func keyboardWillShow(duration: TimeInterval, animationOptions: UIView.AnimationOptions, keyboardHeight: CGFloat)
    func keyboardWillHide(duration: TimeInterval, animationOptions: UIView.AnimationOptions, keyboardHeight: CGFloat)
}

extension KeyboardEventsDelegate {
    // Make optional
    func keyboardWillShow(duration: TimeInterval, animationOptions: UIView.AnimationOptions, keyboardHeight: CGFloat) {}
    func keyboardWillHide(duration: TimeInterval, animationOptions: UIView.AnimationOptions, keyboardHeight: CGFloat) {}
}

class KeyboardManager {
    
    var delegate: KeyboardEventsDelegate?
    lazy var hideKeyboardGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTap))
    }()
    
    func beginMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func stopMonitoring() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowOrHide(_ notification: Notification) {
        if let delegate = delegate {
            let info = (notification as NSNotification).userInfo ?? [:]
            let duration = TimeInterval((info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.25)
            let curve = UInt((info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0)
            let options = UIView.AnimationOptions(rawValue: curve)
            let keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
            let keyboardHeight = (keyboardRect.height - bottomSafeAreaHeight())
            if notification.name == UIResponder.keyboardWillShowNotification {
                delegate.keyboardWillShow(duration: duration, animationOptions: options, keyboardHeight: keyboardHeight)
                delegate.hideKeyboardByTouchView?.addGestureRecognizer(hideKeyboardGesture)
            } else if notification.name == UIResponder.keyboardWillHideNotification {
                delegate.keyboardWillHide(duration: duration, animationOptions: options, keyboardHeight: keyboardHeight)
                delegate.hideKeyboardByTouchView?.removeGestureRecognizer(hideKeyboardGesture)
            }
        }
    }
    
    @objc func hideKeyboardByTap() {
        if let delegate = delegate, let touchView = delegate.hideKeyboardByTouchView {
            touchView.endEditing(true)
        }
    }
    
    private func bottomSafeAreaHeight() -> CGFloat {
        guard let rootView = UIApplication.shared.keyWindow else { return 0 }
        if #available(iOS 11.0, *) {
            return rootView.safeAreaInsets.bottom
        } else {
            return 0
        }
    }
    
}
