//
//  SelectedView.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

class SelectedView: UIView {
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 15)
        return textLabel
    }()

    private lazy var downImageView: UIImageView = {
        let downImageView = UIImageView()
        downImageView.translatesAutoresizingMaskIntoConstraints = false
        downImageView.image = UIImage(systemName: "chevron.down")
        downImageView.tintColor = .white
        downImageView.contentMode = .scaleAspectFit
        return downImageView
    }()

    public weak var delegate: CustomViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        observeUserDefaultsChanges()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        observeUserDefaultsChanges()
    }

    private func setupView() {
        self.backgroundColor = .black
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 8

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPopover))
        self.addGestureRecognizer(tapGesture)

        self.addSubview(textLabel)
        self.addSubview(downImageView)

        downImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-4)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }

        textLabel.snp.makeConstraints { make in
            make.trailing.equalTo(downImageView.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
    }

    @objc private func showPopover() {
        delegate?.customViewDidTap(self)
    }

    private func observeUserDefaultsChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange(_:)), name: .userDefaultsDidChange, object: nil)
    }

    @objc private func userDefaultsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        DispatchQueue.main.async {
            let key: String
            switch self.tag {
            case 101:
                key = "firstSelectedView"
            case 102:
                key = "secondSelectedView"
            default:
                return
            }
            if let tupleArray = userInfo[key] as? [String], tupleArray.count == 2 {
                self.textLabel.text = tupleArray[1]
            }
        }
    }

    func setText(text: String) {
        DispatchQueue.main.async {
            self.textLabel.text = text
        }
    }
}

protocol CustomViewDelegate: AnyObject {
    func customViewDidTap(_ customView: SelectedView)
}
