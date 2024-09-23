//
//  ArrowView.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

// MARK: - Class Bone
final class ArrowView: UIView {
    // MARK: Attributes
    private lazy var upImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.up")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var downImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var emptyView: UIView = {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(upImageView)
        stackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(downImageView)
        return stackView
    }()

    // MARK: Cons & Decons
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - Setup UI
extension ArrowView {
    private func setupView() {
        addSubview(stackView)
        self.layer.cornerRadius = 4

        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }

    func setVisibility(arrow: ArrowType) {
        self.backgroundColor = arrow.viewColor
        switch arrow {
        case .down:
            upImageView.isHidden = true
            downImageView.isHidden = false
        case .up:
            upImageView.isHidden = false
            downImageView.isHidden = true
        case .stable:
            upImageView.isHidden = true
            downImageView.isHidden = true
        }
    }
}
