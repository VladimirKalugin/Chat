//
//  ViewController.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 22.06.2021.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var newMessageTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var messages = [Message]()
    var chat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        newMessageTextView.delegate = self
        addTouch()
        setupView()
        showHideKeyboard()
        if let chat = chat {
            messages = StorageManager.shared.fetchMessages(from: chat).sorted(by: { (one, two) -> Bool in
                one.time < two.time
            })
        }
        collectionView.setCollectionViewLayout(CustomFlowLayout(), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sectionNumber = 0
        let indexPath = IndexPath(row: self.collectionView.numberOfItems(inSection: sectionNumber) - 1, section: sectionNumber)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if messages.isEmpty {
            guard let chat = chat else { return }
            StorageManager.shared.delete(chat)
        }
    }
    
    @IBAction func sendMessageAction(_ sender: UIButton) {
        if let text = newMessageTextView.text,
           newMessageTextView.text?.count ?? 0 > 0,
           newMessageTextView.text != "Enter your message..." {
            guard let chat = chat else { return }
            StorageManager.shared.createMessage(chat: chat, text: text, time: Date(), isReciver: Bool.random())
            self.chat = StorageManager.shared.fetchChat(from: chat.id)
            messages = StorageManager.shared.fetchMessages(from: chat).sorted(by: { (one, two) -> Bool in
                one.time < two.time
            })
            
            let cellIndex = IndexPath(item: messages.count - 1 , section: 0)
            collectionView.insertItems(at: [cellIndex])
            
            let sectionNumber = 0
            let indexPath = IndexPath(row: self.collectionView.numberOfItems(inSection: sectionNumber) - 1, section: sectionNumber)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            
            newMessageTextView.text = nil
        
            setColorForButton()
        }
       
    }
    
    private func addTouch() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        collectionView.addGestureRecognizer(recognizer)
    }
    
    private func showHideKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            self.newMessageTextView.text = "Enter your message..."
            self.newMessageTextView.textColor = UIColor(hexaString: "000000",alpha: 0.3)
        }
    }
    
    @objc private func touch() {
        self.view.endEditing(true)
    }
    
    // Setup Views
    private func setupView() {
        self.collectionView.backgroundColor = UIColor(hexaString: "F4F3F3")
        self.collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
        newMessageTextView.layer.cornerRadius = 5
        newMessageTextView.backgroundColor = UIColor(hexaString: "E7E7E7")
        newMessageTextView.font = UIFont(name: "system", size: 17)
        newMessageTextView.text = "Enter your message..."
        newMessageTextView.textColor = UIColor(hexaString: "000000",alpha: 0.3)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowRadius = 7
        navigationController?.navigationBar.layer.shadowColor = UIColor(hexaString: "000000").cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.38
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.2)
        
        messageView.backgroundColor = UIColor(hexaString: "FFFFFF")
        messageView.layer.shadowColor = UIColor(hexaString: "000000").cgColor
        messageView.layer.shadowOpacity = 0.5
        messageView.layer.shadowRadius = 4
        messageView.layer.shadowOffset.height = 0.2
        
        setColorForButton()
    }
    
    private func setColorForButton() {
        let sendImage = UIImage(named: "iconSend")
        let tintedImage = sendImage?.withRenderingMode(.alwaysTemplate)
        sendMessageButton.setImage(tintedImage, for: .normal)
        sendMessageButton.tintColor = UIColor(hexaString: "E11C28")
    }
}

//MARK: - Collection View Delegate, DataSource, FlowLayout

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath) as! ChatCollectionViewCell
    
        let message = messages[indexPath.row]
        let time = getTimeOfMessage(date: message.time)

        let size = CGSize(width: collectionView.frame.width - collectionView.frame.width / 3,
                          height: collectionView.frame.height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrameForMessage = NSString(string: message.text.trimmingCharacters(in: .whitespacesAndNewlines)).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
        let estimatedFrameForTime = NSString(string: time).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], context: nil)
        
        if !message.isReciver {
            cell.messageTextView.text = message.text.trimmingCharacters(in: .whitespacesAndNewlines)
            cell.messageTextView.textAlignment = .left
            cell.messageTextView.textColor = UIColor(hexaString: "000000")
            cell.messageTextView.backgroundColor = UIColor(hexaString: "FFFFFF")
            cell.timeLabel.text = time
            cell.messageTextView.frame = CGRect(x: 16, y: 16, width: estimatedFrameForMessage.width + 16 , height: estimatedFrameForMessage.height + 20)
            cell.timeLabel.frame = CGRect(x: estimatedFrameForMessage.width + 36, y: estimatedFrameForMessage.height + 20, width: estimatedFrameForTime.width + 30, height: estimatedFrameForTime.height)
            
            return cell
        } else {
            cell.messageTextView.text = message.text.trimmingCharacters(in: .whitespacesAndNewlines)
            cell.messageTextView.textAlignment = .right
            cell.messageTextView.textColor = .white
            cell.messageTextView.backgroundColor = UIColor(hexaString: "D9D8D8")
            cell.timeLabel.text = time
            cell.messageTextView.frame = CGRect(x: collectionView.bounds.width - estimatedFrameForMessage.width - 16 - 8, y: 16, width: estimatedFrameForMessage.width + 16, height: estimatedFrameForMessage.height + 20)
            cell.timeLabel.frame = CGRect (x: collectionView.bounds.width - estimatedFrameForMessage.width - 60, y: estimatedFrameForMessage.height + 20, width: estimatedFrameForTime.width + 16 , height: estimatedFrameForTime.height)
            
            return cell
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 15, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  
        let message = messages[indexPath.row]
        let time = getTimeOfMessage(date: message.time)
        
        let size = CGSize(width: collectionView.frame.width - collectionView.frame.width / 3,
                          height: collectionView.frame.height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: message.text.trimmingCharacters(in: .whitespacesAndNewlines) + time).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
        estimatedFrame.size.height += 20
                
        return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 20)
        }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    private func getTimeOfMessage(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}

//MARK: - TextView Delegate

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hexaString: "000000",alpha: 0.3) {
            textView.text = nil
            textView.font = UIFont(name: "system", size: 18)
            textView.textColor = UIColor(hexaString: "000000")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.font = UIFont(name: "system", size: 18)
            textView.text = "Enter your message..."
            textView.textColor = UIColor(hexaString: "000000",alpha: 0.3)
        }
    }

}
