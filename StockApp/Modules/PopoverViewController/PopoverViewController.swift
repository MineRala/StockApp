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
        tableView.register(DataTypeTableViewCell.self, forCellReuseIdentifier: "DataTypeTableViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
       
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(16)
        }
        
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        
        view.addSubview(tableView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(16)
        }
        
        
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
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTypeTableViewCell",for: indexPath) as? DataTypeTableViewCell else {
            return UITableViewCell()
        }
        //                cell.setCell(model: viewModel.getMovie(index: indexPath.row))
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - TableView Delegate
extension PopoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        viewModel.didSelectRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        viewModel.heightForRowAt
        40
    }
}
