//
//  StockTableViewCell.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

// MARK: - Class Bone
final class StockTableViewCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var arrowView: ArrowView = {
        let view = ArrowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setVisibility(arrow: .stable)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var valueLabelOne: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private lazy var valueLabelTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
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
        
        containerView.addSubview(arrowView)
        
        arrowView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview()
            make.width.equalTo(24)
        }
        
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(arrowView.snp.top).offset(4)
            make.left.equalTo(arrowView.snp.right).offset(8)
            make.height.equalTo(16)
        }
        
        containerView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel.snp.left)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(12)
        }
        
        containerView.addSubview(valueLabelTwo)
        
        valueLabelTwo.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(titleLabel)
        }
        
        containerView.addSubview(valueLabelOne)
        
        valueLabelOne.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalTo(valueLabelTwo.snp.left).offset(-32)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(titleLabel)
        }
    }
}

// MARK: - Set Cell
extension StockTableViewCell {
    public func setTitle(title: String) {
        titleLabel.text = title
    }

    public func setData(model: DataModel) {
        dateLabel.text = model.clo

        updateValueLabel(valueLabel: valueLabelOne, key: UserDefaultsManager.shared.firstSelectedViewKey, model: model)
        updateValueLabel(valueLabel: valueLabelTwo, key: UserDefaultsManager.shared.secondSelectedViewKey, model: model)
    }

    private func updateValueLabel(valueLabel: UILabel, key: String?, model: DataModel) {
        guard let key else {
            valueLabel.text = nil
            valueLabel.textColor = .white
            return
        }

        valueLabel.text = setValue(key: key, model: model)

        if key == "ddi" || key == "pdd" {
            valueLabel.textColor = valueLabel.text?.checkNumberSign()
        } else {
            valueLabel.textColor = .white
        }
    }

    public func setHeighlited(date: String) {
        containerView.backgroundColor = .gray
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.containerView.backgroundColor = .black
        }
    }

    public func setArrow(arrow: ArrowType) {
        let isLASSelected = UserDefaultsManager.shared.firstSelectedViewKey == "las" || UserDefaultsManager.shared.secondSelectedViewKey == "las"
        let selectedArrow = isLASSelected ? arrow : .stable
        arrowView.setVisibility(arrow: selectedArrow)
    }


    public func setValue(key: String, model: DataModel) -> String {
        if key == "las" {
            return model.las ?? ""
        } else if key == "pdd" {
            return model.pdd ?? ""
        } else if key == "ddi" {
            return model.ddi ?? ""
        } else if key == "low" {
            return model.low ?? ""
        } else if key == "hig" {
            return model.hig ?? ""
        } else if key == "buy" {
            return model.buy ?? ""
        } else if key == "sel" {
            return model.sel ?? ""
        } else if key == "pdc" {
            return model.pdc ?? ""
        } else if key == "cei" {
            return model.cei ?? ""
        } else if key == "flo" {
            return model.flo ?? ""
        } else if key == "gco" {
            return model.gco ?? ""
        }
        return ""
    }
}
