//
//  DataTypeTableViewCell.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

//MARK: - Class Bone
final class DataTypeTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Son"
        return label
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
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
extension DataTypeTableViewCell {
    private func configureCell() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
        
        contentView.addSubview(checkmarkImageView)
        
        checkmarkImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
    }
}

//MARK: - Set Cell
extension DataTypeTableViewCell {
    func setCell(dataType: String, selectedViewOption: SelectedViewOption) {
        titleLabel.text = dataType
        let retrievedValue: String?

        switch selectedViewOption {
        case .first:
            retrievedValue = UserDefaultsManager.shared.firstSelectedViewName
        case .second:
            retrievedValue = UserDefaultsManager.shared.secondSelectedViewName
        }
        checkmarkImageView.isHidden = !(retrievedValue == dataType)
    }
}
