//
//  HomeViewController.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = .black
        
        let titleLabel = UILabel()
        titleLabel.text = "Sembol"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(titleLabel)
        
        let button = UIButton(type: .system)
               button.setTitle("Son ", for: .normal)
               button.setTitleColor(.white, for: .normal)
               button.backgroundColor = .black
               button.layer.borderColor = UIColor.gray.cgColor
               button.layer.borderWidth = 3.0
               button.layer.cornerRadius = 8.0
               button.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(systemName: "arrow.right") // İkon olarak sistem ikonunu kullanıyoruz
               button.setImage(icon, for: .normal)
               button.tintColor = .white // İkonun rengini ayarlayın
               
               // İkon ve başlık için içerik insets ayarlayın
               button.contentHorizontalAlignment = .left // İçeriği sola yasla
               button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0) // İkon için sol boşluk
               button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0) // Başlık için sağ boşluk
               
               button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
               

        header.addSubview(button)
              
         
        
        titleLabel.snp.makeConstraints { make in
                   make.leading.equalToSuperview().offset(28)
                   make.trailing.equalToSuperview()
                   make.top.equalToSuperview().offset(10)
                   make.bottom.equalToSuperview().offset(-10)
        }
        
        button.snp.makeConstraints { make in
                   make.trailing.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.3)
                   
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
               }
        
        return header
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "StockTableViewCell")
        return tableView
    }()
    
    @objc func buttonTapped(_ sender: UIButton) {
        let popoverVC = PopoverViewController()
              popoverVC.modalPresentationStyle = .popover
              
              if let popoverPresentationController = popoverVC.popoverPresentationController {
                  popoverPresentationController.sourceView = sender
                  popoverPresentationController.sourceRect = sender.bounds
                  popoverPresentationController.permittedArrowDirections = .up
                  popoverPresentationController.delegate = self
              }
              
              present(popoverVC, animated: true, completion: nil)
          }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setDataTypeDefaultValue()
    }
    
    func setDataTypeDefaultValue() {
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "dataTypeOne") == nil {
            // Varsayılan değer ayarlama
            let userType: DataType = .last // Varsayılan kullanıcı tipi
            defaults.set(userType.text, forKey: "dataTypeOne")
        }
        
        if defaults.string(forKey: "dataTypeTwo") == nil {
            // Varsayılan değer ayarlama
            let userType: DataType = .pDifference // Varsayılan kullanıcı tipi
            defaults.set(userType.text, forKey: "dataTypeTwo")
        }
        //               // Kullanıcı tipini okuma
        //               if let savedUserType = defaults.string(forKey: "userType"),
        //                  let userType = UserType(rawValue: savedUserType) {
        //                   print("Kullanıcı tipi: \(userType)")
        //               }
    }
    
    func setUpUI() {
        self.view.backgroundColor = .black
        
        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        
    }
}

//MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        viewModel.numberOfRowsInSection
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockTableViewCell",for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        //                cell.setCell(model: viewModel.getMovie(index: indexPath.row))
        cell.selectionStyle = .none
        cell.backgroundColor = .black
        return cell
    }
}

//MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        viewModel.didSelectRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        viewModel.heightForRowAt
        60
    }
}

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // iPhone'da popover olarak göstermek için
    }
}
