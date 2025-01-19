//
//  LoginViewController.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/17/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class LoginViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    private let loginLabelTitle = UILabel().then { label in
        label.text = "로그인"
        label.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private let emailView = UIView().then { view in
        view.backgroundColor = .customGrayColor
    }
    
    private let passwordView = UIView().then { view in
        view.backgroundColor = .customGrayColor
    }
    
    private let emailImage = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "envelope")
        imageView.tintColor = .black
    }
    
    private let emailTextField = UITextField().then { textField in
        textField.placeholder = "email@example.com"
    }
    
    private let passwordTextField = UITextField().then { textField in
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
    }
    
    private let passwordImage = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "lock")
        imageView.tintColor = .black
    }
    
    private let emailLabelTitle = UILabel().then { label in
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 13.6, weight: .regular)
    }
    
    private let passwordLabelTitle = UILabel().then { label in
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 13.6, weight: .regular)
    }
    
    private let loginButton = UIButton().then { button in
        button.setTitle("로그인 하기", for: .normal)
        button.backgroundColor = .buttonColor
    }
    
    private let goSignUpButton = UIButton().then { button in
        button.setTitle("회원가입 하기", for: .normal)
        button.setTitleColor(.buttonColor, for: .normal)
        button.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        addTapGesture()
    }
    
    private func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        [
            emailImage,
            emailTextField
        ].forEach { emailView.addSubview($0) }
        
        [
            passwordImage,
            passwordTextField
        ].forEach { passwordView.addSubview($0) }
        
        [
            loginLabelTitle,
            emailLabelTitle,
            emailView,
            passwordLabelTitle,
            passwordView,
            loginButton,
            goSignUpButton
        ].forEach { view.addSubview($0) }
        
        loginLabelTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        emailLabelTitle.snp.makeConstraints { make in
            make.top.equalTo(loginLabelTitle.snp.bottom).offset(50)
            make.leading.equalToSuperview().inset(40)
        }
        
        emailView.snp.makeConstraints { make in
            make.top.equalTo(emailLabelTitle.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        passwordLabelTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.top.equalTo(emailView.snp.bottom).offset(30)
        }
        
        passwordView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(50)
            make.top.equalTo(passwordLabelTitle.snp.bottom).offset(10)
        }
        
        emailImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(30)
            make.width.equalTo(35)
        }
        
        passwordImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(30)
            make.width.equalTo(35)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(emailImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        goSignUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}

extension LoginViewController {
    
    private func bindUI() {
        
        let input = LoginViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
            loginButtonTap: loginButton.rx.tap,
            goSignUpButton: goSignUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginResult
            .drive(onNext: { [weak self] result in
                guard let self else { return }
                let alertMessage = AlertMessageModel(title: "로그인", message: "회원이 아닙니다.\n회원가입을 진행해주세요.", yesButtonTitle: nil, cancelButtonTitle: "확인", defaultButtonTitle: nil)
                let viewModel = LoginResultViewModel(userEmail: emailTextField.rx.text.orEmpty.asObservable())
                result ? self.navigationController?.pushViewController(LoginResultController(viewModel: viewModel), animated: true) : showAlert(alertModel: alertMessage, Action: nil)
            }).disposed(by: disposeBag)
        
        output.signUpButtonTapped
            .drive(onNext: { [weak self] in
                guard let self else { return }
                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }).disposed(by: disposeBag)
    }
}
