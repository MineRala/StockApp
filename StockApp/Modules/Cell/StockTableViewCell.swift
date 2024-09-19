//
//  StockTableViewCell.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

final class StockTableViewCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stateView: StateView = {
        let view = StateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setVisibility(state: .down)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "XU100"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "13:10:12"
        return label
    }()
    
    
    private lazy var valueOneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "10,2342"
        return label
    }()
    
    private lazy var valueTwoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "%-0.06"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configure Cell
extension StockTableViewCell {
    private func configureCell() {
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.right.equalToSuperview()
        }
        
        containerView.addSubview(stateView)
        
        stateView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview()
            make.width.equalTo(24)
        }
        
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stateView.snp.top).offset(4)
            make.left.equalTo(stateView.snp.right).offset(8)
            make.height.equalTo(16)
        }
        
        containerView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel.snp.left)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(12)
        }
        
        containerView.addSubview(valueTwoLabel)
        
        valueTwoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(titleLabel)
        }
        
        containerView.addSubview(valueOneLabel)
        
        valueOneLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalTo(valueTwoLabel.snp.left).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(titleLabel)
        }
    }
}


enum DataType {
    case last
    case pDifference
    case difference
    case low
    case high
    
    var text: String {
        switch self {
        case .last:
            return "Son"
        case .pDifference:
            return "% Fark"
        case .difference:
            return "Fark"
        case .low:
            return "Düşük"
        case .high:
            return "Yüksek"
        }
    }
}
