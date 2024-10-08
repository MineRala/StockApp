//
//  SelectedView.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

protocol SelectedViewDelegate: AnyObject {
    func selectedViewDidTap(_ selectedView: SelectedView)
}

// MARK: - Class Bone
final class SelectedView: UIView {
    // MARK:  Attributes
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

    // MARK:  Properties
    public weak var delegate: SelectedViewDelegate?

    // MARK: Cons & Decons
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

    private func observeUserDefaultsChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange(_:)), name: .userDefaultsDidChange, object: nil)
    }
}

// MARK - Setup UI
extension SelectedView {
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
}

// MARK: - Set View
extension SelectedView {
    func setText(text: String) {
        DispatchQueue.main.async {
            self.textLabel.text = text
        }
    }
}

// MARK: - Actions
extension SelectedView {
    @objc private func showPopover() {
        delegate?.selectedViewDidTap(self)
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
}
