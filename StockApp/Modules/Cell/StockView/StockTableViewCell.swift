//
//  StockTableViewCell.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

protocol StockTableViewCellInterface: AnyObject {}
// MARK: - Class Bone
final class StockTableViewCell: UITableViewCell {
    // MARK:  Attributes
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

    // MARK: Properties
    private lazy var viewModel: StockTableViewCellViewModelInterface = StockTableViewCellViewModel(view: self)

    // MARK: Cons & Decons
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup UI
extension StockTableViewCell {
    private func setupCell() {
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
            make.width.equalToSuperview().multipliedBy(0.21)
            make.height.equalTo(titleLabel)
        }

        containerView.addSubview(valueLabelOne)

        valueLabelOne.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalTo(valueLabelTwo.snp.left).offset(-32)
            make.width.equalToSuperview().multipliedBy(0.21)
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

        valueLabel.text = viewModel.getValue(key: key, model: model)

        valueLabel.textColor = viewModel.isDifferentValueColor(key: key) ? valueLabel.text?.checkNumberSign() : .white
    }

    public func setHeighlited() {
        containerView.backgroundColor = .gray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.containerView.backgroundColor = .black
        }
    }
    public func setArrow(arrow: ArrowType) {
        arrowView.setVisibility(arrow: arrow)
    }
}

// MARK: - StockTableViewCellInterface
extension StockTableViewCell: StockTableViewCellInterface {}
