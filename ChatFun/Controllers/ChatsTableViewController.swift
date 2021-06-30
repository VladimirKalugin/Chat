//
//  ChatsTableViewController.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 25.06.2021.
//

import UIKit

class ChatsTableViewController: UITableViewController {
    
    var chats = StorageManager.shared.fetchChats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chats = StorageManager.shared.fetchChats()?.sorted(by: { (one, two) -> Bool in
            one.lastMessageTime ?? Date() > two.lastMessageTime ?? Date()
        })
        tableView.reloadData()
        
        if let chats = chats, chats.isEmpty {
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
            label.text = "No Chats"
            label.font = UIFont(name: "system-bold", size: 25)
            label.textColor = UIColor.lightGray
            label.layer.cornerRadius = label.frame.height / 2
            label.textAlignment = .center
            label.isHidden = false
            label.center = self.view.center
            
            view.addSubview(label)
        }
    }
    
    
    @IBAction func addNewChatAction(_ sender: Any) {
        performSegue(withIdentifier: "newChat", sender: nil)
        
    }
    
    private func setupView() {
        let view = UIView()
        tableView.tableFooterView = view
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowRadius = 7
        navigationController?.navigationBar.layer.shadowColor = UIColor(hexaString: "000000").cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.38
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.2)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = chats?.count else { return 1 }
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        if let chats = self.chats, chats.count > 0 {
            let messages = chats[indexPath.row].messages.sorted(by: { (one, two) -> Bool in
                one.timeM < two.timeM
            })
            guard let lastMessage = messages.last else { return cell }
            cell.lastMessageLabel.text = lastMessage.text
            cell.timeLabel.text = getTimeOfMessage(date: lastMessage.timeM)
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showChat", sender: indexPath)
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let chats = chats else { return nil }
        let chat = chats[indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "Delet") { _,_,_ in
            StorageManager.shared.delete(chat)
            self.chats?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        delete.image = UIImage(named: "iconDelete")?.maskWithColor(color: .white)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newChat" {
            let chat = StorageManager.shared.createChat(messages: Set<Message>(), and: UUID())
            guard let chatVC = segue.destination as? ChatViewController else { return }
            chatVC.chat = chat
        }
        if segue.identifier == "showChat" {
            guard let indexPath = sender as? IndexPath else { return }
            guard let chats = chats else { return }
            let chat = chats[indexPath.row]
            guard let chatVC = segue.destination as? ChatViewController else { return }
            chatVC.chat = chat
        }
    }
    
    private func getTimeOfMessage(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
