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
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = nil
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var imageTopConstraint: Constraint?


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
        addSubview(imageView)
        self.layer.cornerRadius = 4

        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()

            self.imageTopConstraint = make.top.equalToSuperview().constraint

        }
    }

    func setVisibility(arrow: ArrowType) {
        self.backgroundColor = arrow.viewColor
        switch arrow {
        case .down:
            imageView.image = UIImage(systemName: "chevron.down")
            imageTopConstraint?.update(offset: 25)
        case .up:
            imageView.image = UIImage(systemName: "chevron.up")
            imageTopConstraint?.update(offset: 0)
        case .stable:
            imageView.image = nil
            imageTopConstraint?.update(offset: 0)
        }
        self.layoutIfNeeded()
    }
}
