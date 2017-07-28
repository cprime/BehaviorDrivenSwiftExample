//
//  Message.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/27/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation

func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.identifier == rhs.identifier
}

class Message: Equatable {
    let identifier: String
    let text: String

    var conversationIdentifer: String?
    var date: Date?
    var audioURL: URL?

    init(identifier: String = UUID().uuidString, text: String) {
        self.identifier = identifier
        self.text = text
    }
}
