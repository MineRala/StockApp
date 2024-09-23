//
//  HomeViewModel.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import Foundation

protocol HomeViewModelInterface: AnyObject {
    var numberOfRowsInSection: Int { get }
    var heightForRowAt: Double { get }

    func deinitt()
    func viewDidLoad()
    func getCod(index: Int) -> String
    func getStockData(index: Int) -> DataModel?
    func getMyPage() -> [MyPage]
    func isCloValueDifferent(current: DataModel, previous: DataModel) -> Bool
    func setArrowType(current: DataModel, previous: DataModel) -> ArrowType
    func checkArrowStable(type: ArrowType) -> ArrowType
}

// MARK: - Class Bone
final class HomeViewModel {
    private weak var view: HomeViewInterface?
    private var myPageDefaults = [MyPageDefaults]()
    private var myPage = [MyPage]()
    private var stockData: [DataModel]?

    private var previousDataForHeighlity = [DataModel]()
    private var previousDataForArrow = [DataModel]()
    private let storeManager: NetworkManagerProtocol
    private var timer: Timer?

    var currentArrowType: ArrowType = .stable
    init(view: HomeViewInterface, storeManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.view = view
        self.storeManager = storeManager
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
    }

    @objc private func fetchData() {
        NetworkManager.shared.makeRequest(endpoint: .stockModel, type: StockModel.self) { result in
            switch result {
            case .success(let stockModel):
                print("Başarıyla alındı: \(stockModel)")
                self.myPageDefaults = stockModel.myPageDefaults
                self.myPage = stockModel.myPage
                self.configureSelectedViewTitles()
                self.fetchSelectedStockData()
                self.view?.tableViewReload()
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchSelectedStockData() {
        guard let first = UserDefaultsManager.shared.firstSelectedViewKey, let second = UserDefaultsManager.shared.secondSelectedViewKey else { return }

        NetworkManager.shared.makeRequest(endpoint: .stockDataModel(fields: "\(first),\(second)", stcs: generateSTCSString()), type: StockDataModel.self, completed: { result in
            switch result {
            case .success(let stockDataModel):
                print("Başarıyla alındı: \(stockDataModel)")
                let newData = stockDataModel.dataModel
                let previousData = self.stockData ?? []
                DispatchQueue.main.async {
                    self.stockData = newData
                    self.view?.tableViewReload()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.uiChangedRows(previousData: previousData, currentData: newData)

                }
            case .failure(let error):
                print(error)
            }
        })
    }

    private func uiChangedRows(previousData: [DataModel], currentData: [DataModel]) {
        for (index, current) in currentData.enumerated() {
            if index < previousData.count {
                let previous = previousData[index]
                self.view?.updateCell(index: index, current: current, previous: previous)
            }
        }
    }

    func observeUserDefaultsChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange(_:)), name: .userDefaultsDidChange, object: nil)
    }

    @objc private func userDefaultsDidChange(_ notification: Notification) {
        fetchSelectedStockData()
    }

    func configureSelectedViewTitles() {
        if UserDefaultsManager.shared.isInitialUserDefaultsEmpty() {
            UserDefaultsManager.shared.setDefaultValues(
                firstSelectedViewKey: myPage[0].key,
                firstSelectedViewName: myPage[0].name,
                secondSelectedViewKey: myPage[1].key,
                secondSelectedViewName :myPage[1].name
            )
        }
        view?.setSelectedViewText()
    }

    private func generateSTCSString() -> String {
        var resultString = ""

        for (index, element) in myPageDefaults.enumerated() {
            resultString += element.tke
            if index < myPageDefaults.count - 1 {
                resultString += "~"
            }
        }
        return resultString
    }
}

// MARK: - HomeViewModelInterface
extension HomeViewModel: HomeViewModelInterface {
    var numberOfRowsInSection: Int {
        myPageDefaults.count
    }

    var heightForRowAt: Double {
        60
    }

    func deinitt() {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self, name: .userDefaultsDidChange, object: nil)
    }

    func viewDidLoad() {
        view?.setupUI()
        fetchData()
        startTimer()
        observeUserDefaultsChanges()
    }

    func getCod(index: Int) -> String{
        myPageDefaults[index].cod
    }

    func getStockData(index: Int) -> DataModel? {
        if let stockData = stockData?[index] {
            return stockData
        }
        return nil
    }

    func getMyPage() -> [MyPage] {
        myPage
    }

    func getArrowType(current: DataModel, previous: DataModel) -> ArrowType {
        let currentPrice = current.las?.toFloat() ?? 0.0
        let previousPrice = previous.las?.toFloat() ?? 0.0

        if currentPrice < previousPrice {
            return .down
        } else if currentPrice > previousPrice {
            return .up
        } else {
            return .stable
        }
    }

    func isCloValueDifferent(current: DataModel, previous: DataModel) -> Bool {
        current.clo != previous.clo
    }

    func setArrowType(current: DataModel, previous: DataModel) -> ArrowType {
        if UserDefaultsManager.shared.isLASKeySelected {
            if let currentLasValue = current.las?.toFloat(), let previousLasValue = previous.las?.toFloat() {
                if currentLasValue > previousLasValue {
                    return .up
                }
                if currentLasValue < previousLasValue {
                    return .down
                }
            }
        }
        return currentArrowType
    }

    func checkArrowStable(type: ArrowType) -> ArrowType {
        if type != .stable {
            currentArrowType = type
        }
        return currentArrowType
    }
}
