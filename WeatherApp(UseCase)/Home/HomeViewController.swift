//
//  HomeViewController.swift
//  WeatherApp(UseCase)
//
//  Created by MT on 3/28/22.
//

import  UIKit

final class HomeViewController: UIViewController {
    static func create() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        viewController.viewModel = HomeViewModel()
        return viewController
    }

    @IBOutlet weak var tableView: UITableView!

    private var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboard()
        setupView()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadViewedCities()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let title = viewModel.cities[indexPath.row]
        cell.config(with: title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.didSelectCity(at: indexPath.row)
        pushToCityViewController(with: city)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.beginSearching()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.endSearching()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(with: searchText)
    }
}

private extension HomeViewController {
    func setupView() {
        setUpNavigationBar()
        setupTableView()
    }

    func setupBinding() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func setUpNavigationBar() {
        title = "Home"
        setupSearchController()
    }

    func setupSearchController() {
        let controller = UISearchController()
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search..."
        controller.searchBar.autocapitalizationType = .none
        controller.searchBar.showsCancelButton = true
        controller.searchBar.delegate = self
        navigationItem.searchController = controller
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.separatorInset.left = 16
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
    }

    func pushToCityViewController(with city: String) {
        let cityViewController = CityViewController.create(city: city)
        navigationController?.pushViewController(cityViewController, animated: true)
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = getKeyboardSize(from: notification) else { return }
        tableView.contentInset.bottom += keyboardSize.height
    }

    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset.bottom = 0
    }

    func getKeyboardSize(from notification: Notification) -> CGRect? {
        let value = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        return value?.cgRectValue
    }
}
