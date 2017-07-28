//
//  ConversationController.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/27/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Intrepid

class ConversationController {
    let apiClient: APIClient
    let conversation: Conversation

    init(conversation: Conversation, apiClient: APIClient) {
        self.conversation = conversation
        self.apiClient = apiClient
    }

    func sendMessage(_ message: Message, completion: @escaping (Result<Message>) -> Void) {
        apiClient.create(message) { result in
            if let createdMessage = result.value {
                self.conversation.sentMessages.append(createdMessage)
            } else {
                self.conversation.pendingMessages.append(message)
            }
            completion(result)
        }
    }
}
