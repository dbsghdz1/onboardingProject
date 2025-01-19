//
//  LoginResultViewModel.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/19/25.
//

import RxCocoa
import RxSwift
import Foundation

final class LoginResultViewModel: ViewModelType {
    
    private let coreDataManager = CoreDataManager.shared
    let userEmail: Observable<String>
    
    init(userEmail: Observable<String>) {
        self.userEmail = userEmail
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let logOutButtonTap: ControlEvent<Void>
        let deleteAccountTap: ControlEvent<Void>
        let goLoginButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let viewDidLoad: Driver<Users>
        let logOutButtonTapped: Driver<Void>
        let deleteAccountTapped: Driver<Void>
        let goLoginButtonTap: Driver<Void>
    }
    
    
    func transform(input: Input) -> Output {
        let viewDidLoad = input.viewDidLoad
            .withLatestFrom(userEmail)
            .flatMap { [weak self] email -> Observable<Users> in
                guard let self else { return Observable.empty() }
                if let loggedInUser = self.coreDataManager.readUserByEmail(email: email) {
                    UserDefaults.standard.set(true, forKey: "isLogginUser")
                    UserDefaults.standard.set(email, forKey: "recentLoginEmail")
                    return Observable.just(loggedInUser)
                } else {
                    return Observable.empty()
                }
            }
            .asDriver(onErrorJustReturn: Users())
        
        let logOutButtonTap = input.logOutButtonTap
            .flatMap {
                UserDefaults.standard.set(false, forKey: "isLogginUser")
                return Observable.just(())
            }
            .asDriver(onErrorJustReturn: ())
        
        let deleteAccountTap = input.deleteAccountTap
            .withLatestFrom(userEmail)
            .flatMap { [weak self] email -> Observable<Void> in
                guard let self else { return Observable.just(()) }
                coreDataManager.deleteUser(email: email)
                UserDefaults.standard.set(false, forKey: "isLogginUser")
                return Observable.just(())
            }
            .asDriver(onErrorJustReturn: ())
        
        let goLoginButtonTap = input.goLoginButtonTap
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            viewDidLoad: viewDidLoad,
            logOutButtonTapped: logOutButtonTap,
            deleteAccountTapped: deleteAccountTap,
            goLoginButtonTap: goLoginButtonTap
        )
    }
    
}
