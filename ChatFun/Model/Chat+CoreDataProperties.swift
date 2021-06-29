//
//  Chat+CoreDataProperties.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 25.06.2021.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        let request = NSFetchRequest<Chat>(entityName: "Chat")
        request.returnsObjectsAsFaults = false
        return request
    }

    @NSManaged public var lastMessageTime: Date?
    @NSManaged public var id: UUID
    @NSManaged public var messages: Set<Message>

}

// MARK: Generated accessors for message
extension Chat {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)

}
