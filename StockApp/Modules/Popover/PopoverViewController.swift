//
//  PopoverViewController.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import Foundation
import UIKit

protocol PopoverViewInterface: AnyObject {}

// MARK: - Class Bone
final class PopoverViewController: UIViewController {
    // MARK:  Attributes
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
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
    
    // MARK: Properties
    private let myPage: [MyPage]
    private lazy var viewModel: PopoverViewModelInterface = {
        return PopoverViewModel(view: self, myPage: myPage)
    }()
    
    // MARK: Cons & Decons
    init(myPage: [MyPage]) {
        self.myPage = myPage // Önce myPage'i başlat
        super.init(nibName: nil, bundle: nil) // Sonra süper init çağrısı
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setOption(option: SelectedViewOption) {
        viewModel.setSelectedViewOption(option: option)
    }
}

// MARK: - Setup UI
extension PopoverViewController {
    private func setupUI() {
        preferredContentSize = CGSize(width: 220, height: (viewModel.numberOfRowsInSection * 35) + 40)
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
        viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTypeTableViewCell",for: indexPath) as? DataTypeTableViewCell, let option = viewModel.getSelectedViewOption() else { return UITableViewCell() }
        cell.setCell(dataType: viewModel.getDataName(index: indexPath.row), selectedViewOption: option)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - TableView Delegate
extension PopoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRowAt(index: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(viewModel.heightForRowAt)
    }
}

// MARK: - PopoverViewInterface
extension PopoverViewController: PopoverViewInterface {}
