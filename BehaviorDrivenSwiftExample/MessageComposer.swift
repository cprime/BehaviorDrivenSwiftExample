//
//  MessageComposer.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/24/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Intrepid

class MessageComposer {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func sendTextMessage(_ message: Message, completion: @escaping (Result<Message>) -> Void) {
        apiClient.create(message, completion: { result in
            switch result {
            case .success(let remoteMessage):
                completion(.success(remoteMessage))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func sendVoiceMessage(_ message: Message, data: Data, completion: @escaping (Result<Message>) -> Void) {
        apiClient.uploadFile(data) { result in
            switch result {
            case .success(let remoteURL):
                message.audioURL = remoteURL
                self.apiClient.create(message, completion: { result in
                    switch result {
                    case .success(let remoteMessage):
                        completion(.success(remoteMessage))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

