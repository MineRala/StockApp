//
//  HomeViewController.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit
import SnapKit

protocol HomeViewInterface: AnyObject {
    func setupUI()
    func setSelectedViewText()
    func tableViewReload()
    func updateCell(index: Int, current: DataModel, previous: DataModel)
}

//MARK: - Class Bone
final class HomeViewController: UIViewController {
    // MARK:  Attributes
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
        view.delegate = self
        return view
    }()

    private lazy var selectedViewSecond: SelectedView = {
        let view = SelectedView()
        view.tag = 102
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

    // MARK: Properties
    private lazy var viewModel: HomeViewModelInterface = HomeViewModel(view: self)

    // MARK: Cons & Decons
    deinit {
        viewModel.deinitt()
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
}

//MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockTableViewCell",for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        cell.setTitle(title: viewModel.getCod(index: indexPath.row))
        if let model = viewModel.getStockData(index: indexPath.row) {
            cell.setData(model: model)
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
        CGFloat(viewModel.heightForRowAt)
    }
}

//MARK: - UIPopoverPresentationControllerDelegate
extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // iPhone'da popover olarak göstermek için
    }
}

// MARK: - SelectedViewDelegate
extension HomeViewController: SelectedViewDelegate {
    func selectedViewDidTap(_ selectedView: SelectedView) {
        let popoverVC = PopoverViewController(myPage: viewModel.getMyPage())
        popoverVC.modalPresentationStyle = .popover

        if let popoverPresentationController = popoverVC.popoverPresentationController {
            popoverPresentationController.sourceView = selectedView
            popoverPresentationController.sourceRect = selectedView.bounds
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.delegate = self
        }

        present(popoverVC, animated: true, completion: nil)

        switch selectedView.tag {
        case 101:
            popoverVC.setOption(option: .first)
        case 102:
            popoverVC.setOption(option: .second)
        default:
            break
        }
    }
}

// MARK: - HomeViewInterface
extension HomeViewController: HomeViewInterface {
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

    func setSelectedViewText() {
        DispatchQueue.main.async {
            self.selectedViewFirst.setText(text: UserDefaultsManager.shared.firstSelectedViewName ?? "")
            self.selectedViewSecond.setText(text: UserDefaultsManager.shared.secondSelectedViewName ?? "")
        }
    }

    func tableViewReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func updateCell(index: Int, current: DataModel, previous: DataModel) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? StockTableViewCell  else { return }
        if viewModel.isCloValueDifferent(current: current, previous: previous) {
            cell.setHeighlited()
        }

        let newArrowType = viewModel.setArrowType(current: current, previous: previous)
        cell.setArrow(arrow: viewModel.checkArrowStable(type: newArrowType))
    }
}
