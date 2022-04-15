//
//  SearchViewController.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 13.04.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Find a location..."
        bar.showsCancelButton = true
        bar.autocapitalizationType = .none
        bar.returnKeyType = .search
        return bar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
        table.layer.cornerRadius = 20
        table.layer.masksToBounds = true
        return table
    }()

    
    private let networkStatusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let viewModel = SearchViewModel(networkManager: NetworkManagerAlamofire())
    let networkMonitor = NetworkMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Search"
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
 


        view.addSubview(networkStatusLabel)
        view.addSubview(tableView)
        
        //MARK: - Bindings
        
        //ViewModelBinding
        viewModel.locationModel.bind { [weak self] responseModel in
            
            guard let responseModel = responseModel else {return}
            //go to detail screen
            let detailViewController = DetailViewController(woeid: responseModel.woeid)
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }

        
        
        //NetworkMonitorBinding
        networkMonitor.startMonitoring()
        networkMonitor.isConnected.bind {[weak self] isConnected in
            guard let isConnected = isConnected else {
                return
            }

            if isConnected {
                DispatchQueue.main.async {
                    self?.networkStatusLabel.backgroundColor = .systemGreen
                    self?.networkStatusLabel.text = "Network status: Connected"
                }
            } else {
                DispatchQueue.main.async {
                    self?.networkStatusLabel.backgroundColor = .systemRed
                    self?.networkStatusLabel.text = "Network status: Not Connected"
                }
            }
        }
        
        
        //viewModel query resul binding
        viewModel.searchResults.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: networkStatusLabel.topAnchor, constant: -20),
            
            networkStatusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            networkStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkStatusLabel.heightAnchor.constraint(equalToConstant: 30)
        ])

    }
    

    

}



extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }


    
    
    //Everytime text change assign viewModels searchString. So we can observe changes
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = (searchBar.text! as NSString).replacingCharacters(in: range, with: text) //raywenderlich
        viewModel.searchString = newString
        return true
    }

}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        guard let title = viewModel.searchResults.value?[indexPath.row].title else {
            return cell
        }
        cell.textLabel?.text = title
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let woeid = viewModel.searchResults.value?[indexPath.row].woeid else {
            return
        }
        let detailViewController = DetailViewController(woeid: woeid)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
}





