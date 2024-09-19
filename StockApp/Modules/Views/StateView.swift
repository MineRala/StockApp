//
//  StateView.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

class StateView: UIView {
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(downImageView)
        stackView.addArrangedSubview(upImageView)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(stackView)
        self.layer.cornerRadius = 4
        
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    func setVisibility(state: StateMode) {
        self.backgroundColor = state.viewColor
        switch state {
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


 enum StateMode {
    case down
    case up
    case stable
    
    var viewColor: UIColor {
        switch self {
        case .up:
            return .green
        case .down:
            return .red
        case .stable:
            return .gray
        }
    }
}
