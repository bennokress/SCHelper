//
//  MakeUppercaseHandler.swift
//  Shortcuts
//
//  Created by Benno Kress on 16.12.20.
//

import Intents

class MakeUppercaseHandler: NSObject, MakeUppercaseIntentHandling {

    func handle(intent: MakeUppercaseIntent, completion: @escaping (MakeUppercaseIntentResponse) -> Void) {
        if let inputText = intent.text {
            let uppercaseText = inputText.uppercased()
            completion(MakeUppercaseIntentResponse.success(result: uppercaseText))
        } else {
            completion(MakeUppercaseIntentResponse.failure(error: "The entered text was invalid"))
        }
    }

    func resolveText(for intent: MakeUppercaseIntent, with completion: @escaping (MakeUppercaseTextResolutionResult) -> Void) {
        if let text = intent.text, !text.isEmpty {
            completion(MakeUppercaseTextResolutionResult.success(with: text))
        } else {
            completion(MakeUppercaseTextResolutionResult.unsupported(forReason: .noText))
        }
    }

}
