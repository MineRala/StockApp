//
//  HomeViewController.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController, CustomViewDelegate {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sembol"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var selectedViewFirst: SelectedView = {
        let view = SelectedView()
        view.tag = 101
//        view.setText(text: UserDefaultsManager.shared.getValue(forKey: "firstSelectedView").1 ?? "")
        view.delegate = self
        return view
    }()

    private lazy var selectedViewSecond: SelectedView = {
        let view = SelectedView()
        view.tag = 102
//        view.setText(text: UserDefaultsManager.shared.getValue(forKey: "secondSelectedView").1 ?? "")
        view.delegate = self
        return view
    }()

    private lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = .black

        header.addSubview(titleLabel)
        header.addSubview(selectedViewFirst)
        header.addSubview(selectedViewSecond)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        selectedViewSecond.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }

        selectedViewFirst.snp.makeConstraints { make in
            make.trailing.equalTo(selectedViewSecond.snp.leading).offset(-15)
            make.width.equalToSuperview().multipliedBy(0.25)
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

    var myPageDefaults: [MyPageDefaults]?
    var myPage: [MyPage]?
    var stockData: [DataModel]?
    var timer: Timer?
    var previousDataForHeighlity: [DataModel] = []
    var previousDataForArrow: [DataModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        startTimer()
        observeUserDefaultsChanges()

    }

    func startTimer() {
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
       }

    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }


    private func observeUserDefaultsChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange(_:)), name: .userDefaultsDidChange, object: nil)
    }
    @objc private func userDefaultsDidChange(_ notification: Notification) {
        fetchSelectedStockData()

    }

    private func configureSelectedViewTitles() {
        if UserDefaultsManager.shared.isInitialUserDefaultsEmpty(), let myPage {
            UserDefaultsManager.shared.setDefaultValues(
                firstSelectedViewKey: myPage[0].key,
                firstSelectedViewName: myPage[0].name,
                secondSelectedViewKey: myPage[1].key,
                secondSelectedViewName :myPage[1].name
            )
        }
        DispatchQueue.main.async {
            self.selectedViewFirst.setText(text: UserDefaultsManager.shared.firstSelectedViewName ?? "")
            self.selectedViewSecond.setText(text:  UserDefaultsManager.shared.secondSelectedViewName ?? "")
        }


    }

    @objc func fetchData() {
        NetworkManager.shared.fetchData(from: "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterviewSettings") { (result: Result<StockModel, Error>) in
            switch result {
            case .success(let stockModel):
                print("Başarıyla alındı: \(stockModel)")
                self.myPageDefaults = stockModel.myPageDefaults
                self.myPage = stockModel.myPage
                self.configureSelectedViewTitles()
                self.fetchSelectedStockData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }

    func highlightChangedRows() {
        guard let currentData = stockData else { return }

        for (index, current) in currentData.enumerated() {
            if index < previousDataForHeighlity.count {
                let previous = previousDataForHeighlity[index]

                // "clo" alanını karşılaştır
                if current.clo != previous.clo {
                    // Değişiklik varsa, ilgili hücreyi vurgula
                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? StockTableViewCell {
                        cell.setHeighlited(date: current.clo) // Vurgulama fonksiyonunu çağır
                    }
                }
            }
        }

        // Yeni verileri sakla
        previousDataForHeighlity = currentData
    }


    func lastPriceArrowUpdates() {
        guard let currentData = stockData else { return }

        // currentData'nın uzunluğuna göre işlem yap
        for (index, current) in currentData.enumerated() {
            // previousDataForArrow dizisinin uzunluğuna göre sınırlandırma
            if index < previousDataForArrow.count {
                let previous = previousDataForArrow[index]

                // Hücreyi bul ve arrow yönünü belirle
                if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? StockTableViewCell {
                    let currentPrice = current.las?.toFloat() ?? 0.0
                    let previousPrice = previous.las?.toFloat() ?? 0.0

                    if currentPrice < previousPrice {
                        cell.setArrow(arrow: .down)
                    } else if currentPrice > previousPrice {
                        cell.setArrow(arrow: .up)
                    } else {
                        cell.setArrow(arrow: .stable)
                    }
                }
            }
        }

        // Yeni verileri sakla
        previousDataForArrow = currentData
    }

    func generateSTCSString() -> String {
        guard let myPageDefaults else { return ""}
        var resultString = ""

        for (index, element) in myPageDefaults.enumerated() {
            resultString += element.tke
            if index < myPageDefaults.count - 1 {
                resultString += "~"
            }
        }
        return resultString
    }

    func fetchSelectedStockData() {
        guard let first = UserDefaultsManager.shared.firstSelectedViewKey, let second = UserDefaultsManager.shared.secondSelectedViewKey else { return }

        NetworkManager.shared.fetchData(from: "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=\(first),\(second )&stcs=\(generateSTCSString())") { (result: Result<StockDataModel, Error>) in
            switch result {
            case .success(let stockDataModel):
                print("Başarıyla alındı: \(stockDataModel)")
                self.stockData = stockDataModel.dataModel
                DispatchQueue.main.async {
                    self.highlightChangedRows()
                    self.lastPriceArrowUpdates()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }

    func setupUI() {
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

    func customViewDidTap(_ customView: SelectedView) {
        guard let myPage else { return }
        let popoverVC = PopoverViewController(myPage: myPage)
        popoverVC.modalPresentationStyle = .popover

        if let popoverPresentationController = popoverVC.popoverPresentationController {
            popoverPresentationController.sourceView = customView
            popoverPresentationController.sourceRect = customView.bounds
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.delegate = self
        }

        present(popoverVC, animated: true, completion: nil)

        // Hangi CustomView'ın tıklandığını kontrol etme
        if customView == selectedViewFirst {
            popoverVC.selectedViewOption = .first
        } else if customView == selectedViewSecond {
            popoverVC.selectedViewOption = .second
        }
    }
}

//MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        viewModel.numberOfRowsInSection
        myPageDefaults?.count ?? 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockTableViewCell",for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        if let stockModel = myPageDefaults?[indexPath.row] {
            cell.setTitle(title: stockModel.cod)
        }
        if let stockDataModel = stockData?[indexPath.row] {
            cell.setData(model: stockDataModel)
        }

        cell.selectionStyle = .none
        cell.backgroundColor = .black
        return cell
    }
}

//MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
