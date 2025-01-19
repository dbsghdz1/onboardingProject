//
//  LoginResultController.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/19/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class LoginResultController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private let viewModel: LoginResultViewModel
    
    init(viewModel: LoginResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let userInfoLabel = UILabel().then { label in
        label.text = ""
    }
    
    private let logOutButton = UIButton().then { button in
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .buttonColor
    }
    
    private let goLoginButton = UIButton().then { button in
        button.setTitle("로그인 하러가기", for: .normal)
        button.backgroundColor = .buttonColor
        button.isHidden = true
    }
    
    private let deleteAccountButton = UIButton().then { button in
        button.setTitle("회원탈퇴", for: .normal)
        button.backgroundColor = .buttonColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        bindUI()
    }
        
    private func configureUI() {
        
        [
            userInfoLabel,
            logOutButton,
            deleteAccountButton,
            goLoginButton
        ].forEach { view.addSubview($0) }
        
        userInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        
        logOutButton.snp.makeConstraints { make in
            make.top.equalTo(userInfoLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
        
        goLoginButton.snp.makeConstraints { make in
            make.top.equalTo(userInfoLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logOutButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
    }
}

extension LoginResultController {
    
    private func bindUI() {
        
        let input = LoginResultViewModel.Input(
            viewDidLoad: Observable.just(()),
            logOutButtonTap: logOutButton.rx.tap,
            deleteAccountTap: deleteAccountButton.rx.tap,
            goLoginButtonTap: goLoginButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewDidLoad
            .drive(onNext: { [weak self] user in
                guard let self else { return }
                self.userInfoLabel.text = "\(user.name ?? "")/ \(user.nickName ?? "")님 환영합니다."
            }).disposed(by: disposeBag)
        
        output.logOutButtonTapped
            .drive(onNext: { [weak self] in
                guard let self else { return }
                    userInfoLabel.text = "로그인 해주세요"
                    deleteAccountButton.isHidden = true
                    logOutButton.isHidden = true
                goLoginButton.isHidden = false
            }).disposed(by: disposeBag)
        
        output.deleteAccountTapped
            .drive(onNext: { [weak self] in
                guard let self else { return }
                if let navigationController = self.navigationController {
                    navigationController.popViewController(animated: true)
                } else {
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .compactMap({ $0.delegate as? SceneDelegate }).first,
                       let window = sceneDelegate.window {
                        window.rootViewController = UINavigationController(rootViewController: LoginViewController())
                        window.makeKeyAndVisible()
                    }
                }
            }).disposed(by: disposeBag)
        
        output.goLoginButtonTap
            .drive(onNext: {
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .compactMap({ $0.delegate as? SceneDelegate }).first,
                   let window = sceneDelegate.window {
                    window.rootViewController = UINavigationController(rootViewController: LoginViewController())
                    window.makeKeyAndVisible()
                }
            }).disposed(by: disposeBag)
    }
}
