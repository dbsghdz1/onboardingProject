//
//  KeyboardSetting.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/19/25.
//
import UIKit

import RxCocoa
import RxSwift

protocol KeyboardReactable: AnyObject {
    var scrollView: UIScrollView! { get set }
    var disposeBag: DisposeBag { get set }
}

extension KeyboardReactable where Self: UIViewController {
    func setTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setKeyboardNotification() {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        keyboardWillShow
            .asDriver(onErrorRecover: { _ in .never()})
            .drive(onNext: { [weak self] noti in
                self?.handleKeyboardWillShow(noti)
            }).disposed(by: disposeBag)
        
        keyboardWillHide
            .asDriver(onErrorRecover: { _ in .never()})
            .drive(onNext: { [weak self] noti in
                self?.handleKeyboardWillHide()
            }).disposed(by: disposeBag)
    }
    
    private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    private func handleKeyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}

