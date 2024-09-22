//
//  PopoverViewController.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import Foundation
import UIKit

final class PopoverViewController: UIViewController {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Kriter Seçiniz"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        tableView.isScrollEnabled = false
        tableView.register(DataTypeTableViewCell.self, forCellReuseIdentifier: "DataTypeTableViewCell")
        return tableView
    }()

    var myPage: [MyPage]
    var selectedViewOption: SelectedViewOption?

    init(myPage: [MyPage]) {
        self.myPage = myPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        preferredContentSize = CGSize(width: 220, height: (myPage.count * 35) + 40)
        view.backgroundColor = .white

        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
        }
    }
}

//MARK: - TableView DataSource
extension PopoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        viewModel.numberOfRowsInSection
        myPage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTypeTableViewCell",for: indexPath) as? DataTypeTableViewCell, let selectedViewOption else { return UITableViewCell() }
        cell.setCell(dataType: myPage[indexPath.row].name, selectedViewOption: selectedViewOption)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - TableView Delegate
extension PopoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedViewOption else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        //        viewModel.didSelectRowAt(index: indexPath.row)
        if indexPath.row < myPage.count {
            let selectedKey = myPage[indexPath.row].key
            let selectedName = myPage[indexPath.row].name

            switch selectedViewOption {
            case .first:
                UserDefaultsManager.shared.setValue(value1: selectedKey, value2: selectedName, forKey: "firstSelectedView")
            case .second:
                UserDefaultsManager.shared.setValue(value1: selectedKey, value2: selectedName, forKey: "secondSelectedView")
            }
        }

        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        viewModel.heightForRowAt
        35
    }
}
