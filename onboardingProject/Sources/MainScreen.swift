//
//  mainScreen.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/19/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MainScreen: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let startButton = UIButton().then { button in
        button.setTitle("시작하기", for: .normal)
        button.backgroundColor = .buttonColor
    }
    
    private let coreDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI() {
        
        view.addSubview(startButton)
        view.backgroundColor = .systemBackground
        
        startButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
}

extension MainScreen {
    
    private func bindUI() {
        let buttonTapped = startButton.rx.tap
        
        buttonTapped
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let email = UserDefaults.standard.string(forKey: "recentLoginEmail") ?? ""
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .compactMap({ $0.delegate as? SceneDelegate }).first,
                   let window = sceneDelegate.window {
                    if UserDefaults.standard.bool(forKey: "isLogginUser") {
                        let viewModel = LoginResultViewModel(userEmail: Observable.just(email))
                        window.rootViewController = LoginResultController(viewModel: viewModel)
                    } else {
                        window.rootViewController = UINavigationController(rootViewController: LoginViewController())
                    }
                    window.makeKeyAndVisible()
                }
            }).disposed(by: disposeBag)
    }
}
