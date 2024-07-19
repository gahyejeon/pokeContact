//
//  PhoneBookViewController.swift
//  pokeContact
//
//  Created by 내꺼다 on 7/12/24.
//

import UIKit

class PhoneBookViewController: UIViewController {
    
    let profileImageView = UIImageView()
    let randomImageButton = UIButton()
    let nameTextView = UITextView()
    let phoneTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "연락처 추가"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        self.navigationItem.titleView = titleLabel

        
        let saveButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyPoke))
        self.navigationItem.rightBarButtonItem = saveButton
        
        setupUI()
    }
    
    func setupUI() {
        // 프로필 이미지 뷰 설정
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 80
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.image = UIImage(named: "profile_placeholder")
        
        view.addSubview(profileImageView)
        
        randomImageButton.translatesAutoresizingMaskIntoConstraints = false
        randomImageButton.setTitle("랜덤 이미지 생성", for: .normal)
        randomImageButton.setTitleColor(.systemGray, for: .normal)
        randomImageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        randomImageButton.addTarget(self, action: #selector(randomImage), for: .touchUpInside)
        
        view.addSubview(randomImageButton)
        
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.font = UIFont.systemFont(ofSize: 17)
        nameTextView.layer.borderColor = UIColor.lightGray.cgColor
        nameTextView.layer.borderWidth = 0.5
        nameTextView.layer.cornerRadius = 5
        
        view.addSubview(nameTextView)
        
        phoneTextView.translatesAutoresizingMaskIntoConstraints = false
        phoneTextView.font = UIFont.systemFont(ofSize: 17)
        phoneTextView.layer.borderColor = UIColor.lightGray.cgColor
        phoneTextView.layer.borderWidth = 0.5
        phoneTextView.layer.cornerRadius = 5
        
        view.addSubview(phoneTextView)
                
        // Autolayout 설정
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 160),
            profileImageView.heightAnchor.constraint(equalToConstant: 160),
                    
            randomImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            randomImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    
            nameTextView.topAnchor.constraint(equalTo: randomImageButton.bottomAnchor, constant: 20),
            nameTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextView.heightAnchor.constraint(equalToConstant: 40),
                    
            phoneTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 20),
            phoneTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneTextView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func randomImage() {
        // 랜덤 이미지 로직 구현
        NetworkManager.shared.fetchRandomPokemon { [weak self] pokemon in
            guard let self = self else { return }
                    
            DispatchQueue.main.async {
                if let pokemon = pokemon {
                    if let url = URL(string: pokemon.sprites.frontDefault) {
                        self.downloadImage(from: url)
                    }
                }
            }
        }
    }
    
    @objc func applyPoke() {
        guard let name = nameTextView.text, !name.isEmpty,
              let phoneNumber = phoneTextView.text, !phoneNumber.isEmpty else {
            return
        }
        
        // 연락처 데이터를 CoreData에 저장
        saveContact(name: name, phoneNumber: phoneNumber, profileImage: profileImageView.image)
        
        // 메인 화면으로 돌아가기
        navigationController?.popViewController(animated: true)
    }
    
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
                
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }
            
        task.resume()
    }
    
    func saveContact(name: String, phoneNumber: String, profileImage: UIImage?) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let newContact = Contact(context: context)
        newContact.name = name
        newContact.phoneNumber = phoneNumber
        if let profileImage = profileImage {
            newContact.profileImageData = profileImage.pngData()
        }
        
        do {
            try context.save()
            
        } catch {
            print("연락처 저장 실패: \(error)")
        }
    }
}
