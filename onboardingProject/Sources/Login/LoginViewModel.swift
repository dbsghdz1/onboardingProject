//
//  LoginViewModel.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/19/25.
//

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    let coreDataManager = CoreDataManager.shared
    
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let loginButtonTap: ControlEvent<Void>
        let goSignUpButton: ControlEvent<Void>
    }
    
    struct Output {
        let loginResult: Driver<Bool>
        let signUpButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let loginButtonTap = input.loginButtonTap
            .withLatestFrom(
                Observable.combineLatest(
                    input.emailText,
                    input.passwordText
                )
            )
            .flatMap { [weak self] email, password in
                guard let self else { return Observable.just(false) }
                let users = self.coreDataManager.fetchAllUsers()
                for user in users {
                    if user.email == email && (user.password == password) {
                        return Observable.just(true)
                    }
                }
                return Observable.just(false)
            }
            .asDriver(onErrorJustReturn: false)
        
        let signUpButtonTapped = input.goSignUpButton
            .asDriver(onErrorJustReturn: ())

        return Output(
            loginResult: loginButtonTap,
            signUpButtonTapped: signUpButtonTapped
        )
    }
}
