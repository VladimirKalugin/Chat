//
//  StorageManagerCD.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 24.06.2021.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    
    //MARK: - Core Data Stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatFun")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: - Public Methods
    func fetchChats() -> [Chat]? {
        do {
            return try viewContext.fetch(Chat.fetchRequest())
        } catch let error {
            print("Failed fetch data \(error)")
            return nil
        }
    }
    
    func fetchChat(from id: UUID) -> Chat? {
        do {
            guard let chats = try viewContext.fetch(Chat.fetchRequest()) as? [Chat] else { return nil }
            for chat in chats {
                if chat.id == id {
                    return chat
                }
                return nil
            }
        } catch let error {
            print(error)
            return nil
        }
        return nil
    }
    
    func fetchMessages(from chat: Chat) -> Set<Message> {
        let chat = getChat(form: chat.id)
            return chat?.messages ?? []
    }
    
    func createChat(messages: Set<Message>, and id: UUID = UUID()) -> Chat {
        let newChat = Chat(context: viewContext)
//        newChat.messages = messages
        newChat.id = id
        saveContext()
        return newChat
    }
    
    func createMessage(chat: Chat, text: String, time: Date, isReciver: Bool) {
        let newMessageCore = Message(context: viewContext)
        newMessageCore.text = text
        newMessageCore.time = time
        newMessageCore.isReciver = isReciver
        chat.lastMessageTime = time
        chat.addToMessages(newMessageCore)
        saveContext()
    }
    
    func delete(_ chat: Chat) {
        viewContext.delete(chat)
        saveContext()
    }
    
    private func getChat(form id: UUID) -> Chat? {
        guard let chats = fetchChats() else { return nil }
        for chat in chats {
            if chat.id == id {
                return chat
            }
        }
        return nil
    }
    
    // MARK: - Core Data Saving Support
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
