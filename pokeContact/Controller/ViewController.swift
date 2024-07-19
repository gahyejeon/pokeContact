//
//  ViewController.swift
//  pokeContact
//
//  Created by 내꺼다 on 7/12/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var contacts: [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "친구 목록"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        
        self.navigationItem.titleView = titleLabel
        
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addPoke))
        addButton.tintColor = .gray
        self.navigationItem.rightBarButtonItem = addButton
        
        setupTableView()
        fetchContacts()

    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.rowHeight = 80
        
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func addPoke() {
        // 연락처저장하는 화면을 쌓음
        self.navigationController?.pushViewController(PhoneBookViewController(), animated: true)
    }

    // UITableView DataSource and Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.name
        cell.phoneLabel.text = contact.phoneNumber
        if let imageData = contact.profileImageData {
            cell.profileImageView.image = UIImage(data: imageData)
        } else {
            cell.profileImageView.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedContact = contacts[indexPath.row]
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.contact = selectedContact
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 저장된 데이터를 불러옴
        // 새로 생긴 데이터로 테이블뷰를 업데이트
        super.viewWillAppear(animated)
        fetchContacts()
        tableView.reloadData()
    }
    
    func fetchContacts() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        // 이름순으로 정렬하기
        let sortDesciptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDesciptor]
        do {
            contacts = try context.fetch(fetchRequest)
            
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
}

// 테이블뷰를 데이터로 그린다
// 추가 버튼을 누른다
// 연락처 저장하는곳 쌓음
// 맨 밑 A화면 PUSH 하면 B화면
// 화면을 그린다
// 랜덤 이미지를 누른다
//
