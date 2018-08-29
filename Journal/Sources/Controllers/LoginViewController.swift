//
//  LoginViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 30..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private let backgroundImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "background"))
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()
    private let loginWithFacebookButton: UIButton = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        layout()
        style()
        
        loginWithFacebookButton.addTarget(self, action: #selector(loginWithFacebook(_:)), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loginWithFacebookButton)
    }
    
    private func layout() {
        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalTo(backgroundImageView.snp.centerY)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(backgroundImageView.snp.centerY)
        }
        
        loginWithFacebookButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func style() {
        titleLabel.text = "로그인"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textColor = UIColor.white
        
        subtitleLabel.text = "환영합니다"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor.white
        
        loginWithFacebookButton.setTitle("페이스북으로 로그인하기", for: .normal)
        loginWithFacebookButton.layer.cornerRadius = 20
        loginWithFacebookButton.layer.borderWidth = 1.0
        loginWithFacebookButton.layer.borderColor = UIColor.white.cgColor
        
        loginWithFacebookButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    @objc private func loginWithFacebook(_ sender: UIButton) {
        
    } 
}
