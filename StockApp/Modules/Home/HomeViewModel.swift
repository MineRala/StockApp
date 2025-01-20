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
    func getMyPage() -> [MyPage]
    func cellViewModel(forRowAt indexPath: IndexPath) -> StockTableViewCellViewModel?
}

// MARK: - Class Bone
final class HomeViewModel {
    private weak var view: HomeViewInterface?
    private var myPageDefaults = [MyPageDefaults]()
    private var myPage = [MyPage]()
    private var stockData: [DataModel]? {
        didSet {
            guard let stockData, let oldValue else { return }
            setCellViewModels(from: oldValue, and: stockData)
        }
    }

    private var cellViewModels: [StockTableViewCellViewModel] = []
    private let storeManager: NetworkManagerProtocol
    private var timer: Timer?

    init(view: HomeViewInterface, storeManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.view = view
        self.storeManager = storeManager
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
    }

    @objc private func fetchData() {
        NetworkManager.shared.makeRequest(endpoint: .stockModel, type: StockModel.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let stockModel):
                self.myPageDefaults = stockModel.myPageDefaults
                self.myPage = stockModel.myPage
                self.configureSelectedViewTitles()
                self.fetchSelectedStockData()
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchSelectedStockData() {
        guard let first = UserDefaultsManager.shared.firstSelectedViewKey, let second = UserDefaultsManager.shared.secondSelectedViewKey else { return }

        NetworkManager.shared.makeRequest(endpoint: .stockDataModel(fields: "\(first),\(second)", stcs: generateSTCSString()), type: StockDataModel.self, completed: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let stockDataModel):
                self.stockData = stockDataModel.dataModel
                self.view?.tableViewReload()
            case .failure(let error):
                print(error)
            }
        })
    }

    private func setCellViewModels(from previousDataArray: [DataModel], and newDataArray: [DataModel]) {
        cellViewModels = previousDataArray.enumerated().compactMap { index, data  in
            getCellViewModel(from: data, and: newDataArray[index], index: index)
        }
    }

    private func getCellViewModel(from previousData: DataModel, and newData: DataModel, index: Int) -> StockTableViewCellViewModel {
        let arrowType = calculateArrowType(from: previousData, to: newData)

        let firstKey = getSelectedKey(default: .las, from: UserDefaultsManager.shared.firstSelectedViewKey)
        let secondKey = getSelectedKey(default: .pdd, from: UserDefaultsManager.shared.secondSelectedViewKey)

        let valueOne = newData.getValue(for: firstKey)
        let valueTwo = newData.getValue(for: secondKey)

        print(previousData.getValue(for: firstKey), valueOne)

        return .init(
            title: getCod(index: index),
            date: newData.clo,
            isHighlighted: newData.clo != previousData.clo,
            arrowType: arrowType,
            valueOne: valueOne,
            valueTwo: valueTwo,
            valueOneColor:  firstKey.isDifferentColor ? valueOne.checkNumberSign() : .white,
            valueTwoColor: secondKey.isDifferentColor ? valueTwo.checkNumberSign() : .white
        )
    }

    private func calculateArrowType(from previousData: DataModel, to newData: DataModel) -> ArrowType {
        if newData.floatLas > previousData.floatLas {
            return .up
        } else if newData.floatLas == previousData.floatLas {
            return .stable
        } else {
            return .down
        }
    }

    private func getSelectedKey(default defaultKey: DataModel.Key, from userKey: String?) -> DataModel.Key {
        return DataModel.Key(rawValue: userKey ?? "") ?? defaultKey
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
                firstSelectedViewKey: myPage[0].key.rawValue,
                firstSelectedViewName: myPage[0].name,
                secondSelectedViewKey: myPage[1].key.rawValue,
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
        cellViewModels.count
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

    func getCod(index: Int) -> String {
        myPageDefaults[index].cod
    }

    func getMyPage() -> [MyPage] {
        myPage
    }

    func cellViewModel(forRowAt indexPath: IndexPath) -> StockTableViewCellViewModel? {
        cellViewModels[safe: indexPath.row]
    }
}
