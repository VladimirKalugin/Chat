//
//  Message+CoreDataProperties.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 25.06.2021.
//
//

import Foundation
import CoreData

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        let request = NSFetchRequest<Message>(entityName: "Message")
        request.returnsObjectsAsFaults = false
        let sortDescription = NSSortDescriptor(key: "time", ascending: true)
        request.sortDescriptors = [sortDescription]
        return request
    }

    
    @NSManaged public var isReciver: Bool
    @NSManaged public var time: Date
    @NSManaged public var text: String
    @NSManaged public weak var chat: Chat?
    
    public var textM: String {
//        guard let textM = text else { return "No text"}
        return text
    }
    public var timeM: Date {
//        guard let timeM = time else { return Date() }
        return time
    }

}
