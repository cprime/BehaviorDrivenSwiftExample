//
//  APIClient.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/27/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Intrepid

protocol APIClient {
    func uploadFile(_ data: Data, completion: @escaping (Result<URL>) -> Void)
    func create(_ message: Message, completion: @escaping (Result<Message>) -> Void)
}
