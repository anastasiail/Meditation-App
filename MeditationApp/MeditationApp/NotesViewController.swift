//
//  NotesViewController.swift
//  MeditationApp
//
//  Created by Anastasia Ilasova on 08.02.2026.
//

import UIKit

class NotesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 125/255, green: 255/255, blue: 227/255, alpha: 1)
        setUpTableView()
        setUpUI()
        loadItems()
    }
    
    private var notes: [String] = []
    
    private func addNote(_ text: String) {
        notes.append(text)
        saveNotes()
        tableView.reloadData()
    }
    
    private let addNoteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add new", for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(UIColor(red: 13/255, green: 89/255, blue: 37/255, alpha: 1), for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var tableView = UITableView()
    
    private func setUpUI() {
        
        addNoteButton.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(addNoteButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            
            addNoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addNoteButton.widthAnchor.constraint(equalToConstant: 100),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func addNoteButtonTapped() {
        
        let alert = UIAlertController(title: "New note", message: "Enter your thoughts...", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            
            guard let textField = alert.textFields?.first, let text = textField.text else { return }
            
            self?.addNote(text)
        })
        
        present(alert, animated: true)
    }
    
    private func setUpTableView() {
        
        tableView.backgroundColor = UIColor(red: 125/255, green: 255/255, blue: 227/255, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func saveNotes() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "SavedNotes")
        }
    }
    
    private func loadItems() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedNotes") {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([String].self, from: savedData) {
                notes = loadedItems
            }
        }
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = notes[indexPath.row]
        cell.backgroundColor = UIColor(red: 125/255, green: 255/255, blue: 227/255, alpha: 1)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
