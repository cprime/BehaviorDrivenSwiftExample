//
//  MockMessageService.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/25/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

@testable import BehaviorDrivenSwiftExample
import Intrepid

enum MessageComposerError: Error {
    case unknown
}

class MockMessageService: MessageService {
    var capturedCreateMessage: Message?
    var stubbedRemoteMessage: Message?
    var stubbedCreateMessageError: Error?
    func create(_ message: Message, completion: @escaping (Result<Message>) -> Void) {
        capturedCreateMessage = message
        DispatchQueue.main.async {
            if let error = self.stubbedCreateMessageError {
                completion(.failure(error))
            } else {
                completion(.success(self.stubbedRemoteMessage!))
            }
        }
    }
}
