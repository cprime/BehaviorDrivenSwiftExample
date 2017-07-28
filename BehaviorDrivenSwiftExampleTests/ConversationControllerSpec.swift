//
//  ConversationControllerSpec.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/27/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

@testable import BehaviorDrivenSwiftExample

import Quick
import Nimble
import Intrepid

class ConversationControllerSpec: QuickSpec {
    override func spec() {
        describe("ConversationController") {
            var apiClient: MockAPIClient!
            var conversation: Conversation!
            var sut: ConversationController!

            beforeEach {
                apiClient = MockAPIClient()
                conversation = Conversation()
                sut = ConversationController(conversation: conversation, apiClient: apiClient)
            }

            describe("sendMessage") {
                var message: Message!
                var capturedResult: Result<Message>?
                beforeEach {
                    message = Message(text: "Hello, World!")
                    capturedResult = nil
                }

                context("when message uploading fails") {
                    beforeEach {
                        apiClient.stubbedCreateMessageError = MockAPIClientError.postError
                        sut.sendMessage(message) { result in
                            capturedResult = result
                        }
                    }
                    it("should add the message to the pending list") {
                        expect(conversation.pendingMessages).toEventually(contain(message))
                    }
                    it("should fail with the post error") {
                        expect(capturedResult?.isFailure).toEventually(beTrue())
                    }
                }
                context("when message uploading succeeds") {
                    beforeEach {
                        apiClient.stubbedCreateMessageError = nil
                        sut.sendMessage(message) { result in
                            capturedResult = result
                        }
                    }
                    it("should add the message to the sent list") {
                        expect(conversation.sentMessages).toEventually(contain(message))
                    }
                    it("should succeed") {
                        expect(capturedResult?.isSuccess).toEventually(beTrue())
                    }
                }
            }
        }
    }
}
