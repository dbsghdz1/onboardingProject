//
//  SignUpViewModel.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/18/25.
//

import CoreData

import RxSwift
import RxCocoa
import RxRelay

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class SignUpViewModel: ViewModelType {
    
    private let coreDataManager = CoreDataManager.shared
    
    struct Input {
        let userName: Observable<String>
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let passwordCheckText: Observable<String>
        let signUpButtonTapped: ControlEvent<Void>
        let userNickName: Observable<String>
    }
    
    struct Output {
        let registerUser: Driver<Bool>
        let emailText: Driver<Bool>
        let passwordText: Driver<Bool>
        let passwordCheckText: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let emailCheck = input.emailText
            .flatMap { [weak self] email in
                guard let self else { return Observable.just(false) }
                if self.emailCheck(email) {
                    return Observable.just(true)
                }
                return Observable.just(false)
            }
            .asDriver(onErrorJustReturn: false)
        
        let passwordCheckText = input.passwordCheckText
            .withLatestFrom(Observable.combineLatest(
                input.passwordText,
                input.passwordCheckText
            ))
            .map { password, passwordCheck -> Bool in
                return password == passwordCheck && !password.isEmpty
            }
        
        let signUpButtonTapped = input.signUpButtonTapped
            .withLatestFrom(
                Observable.combineLatest(
                    input.emailText,
                    input.passwordCheckText,
                    input.passwordText,
                    input.userName,
                    input.userNickName
                )
            )
            .flatMapLatest { [weak self] values -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                let email = values.0
                let passwordCheck = values.1
                let password = values.2
                let userName = values.3
                let nickName = values.4
                
                if !self.emailCheck(email) {
                    return Observable.just(false)
                }
                
                if passwordCheck != password || password.isEmpty {
                    return Observable.just(false)
                }
                
                self.coreDataManager.createUser(name: userName, email: email, password: password, nickName: nickName)
                return Observable.just(true)
            }
            .asDriver(onErrorJustReturn: false)
        
        let passwordText = input.passwordText
            .flatMap { password in
                if password.count < 8 {
                    return Observable.just(false)
                }
                return Observable.just(true)
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            registerUser: signUpButtonTapped,
            emailText: emailCheck,
            passwordText: passwordText,
            passwordCheckText: passwordCheckText.asDriver(onErrorJustReturn: false)
        )
    }
    
    private func emailCheck(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let users = coreDataManager.fetchAllUsers()
        if !emailPredicate.evaluate(with: email) { return false }
        if users.contains(where: { $0.email == email }) { return false }
        return true
    }
}
