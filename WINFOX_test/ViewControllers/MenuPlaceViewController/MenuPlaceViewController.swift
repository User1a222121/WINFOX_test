//
//  MenuPlaceViewController.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 12.06.2022.
//

import UIKit

class MenuPlaceViewController: UIViewController {
    
    //MARK: propirties
    let tableView = UITableView()
    var menu: [MenuModelData] = []
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
    }
    
    //MARK: private func
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupTableView() {
        tableView.frame = CGRect(x: 0.0, y: 0.0,
                                 width: 268,
                                 height: view.frame.height * 0.58)
        tableView.separatorStyle = .singleLine
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        view.addSubview(tableView)
        tableView.register(UINib(nibName:  MenuPlaceCell.reuseId, bundle: nil),
                           forCellReuseIdentifier:  MenuPlaceCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
    }
}

//MARK: extensions
extension MenuPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuPlaceCell.reuseId,
                                                       for: indexPath) as? MenuPlaceCell else { return UITableViewCell() }
        cell.setCell(with: menu[indexPath.row])
        
        return cell
    }
}
