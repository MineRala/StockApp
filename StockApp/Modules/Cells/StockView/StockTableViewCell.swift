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
    var viewModel: StockTableViewCellViewModel? {
        didSet {
            if let viewModel {
                updateUI(viewModel: viewModel)
            }
        }
    }

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
    public func setHeighlited() {
        dateLabel.text = viewModel?.date
        containerView.backgroundColor = .gray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.containerView.backgroundColor = .black
        }
    }

    private func updateUI(viewModel: StockTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        arrowView.setVisibility(arrow: viewModel.arrowType)
        update(label: valueLabelOne, text: viewModel.valueOne, textColor: viewModel.valueOneColor)
        update(label: valueLabelTwo, text: viewModel.valueTwo, textColor: viewModel.valueTwoColor)
    }

    private func update(label: UILabel, text: String, textColor: UIColor) {
        label.text = text
        label.textColor = textColor
    }
}
