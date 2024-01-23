//
//  ChallengeNonUserView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/21/24.
//

import SwiftUI
import MessageUI

struct ChallengeNonUserView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var phoneNumber:String

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let viewController = MFMessageComposeViewController()
        viewController.body = "Download our app for a great experience!"
        viewController.recipients = [phoneNumber]
        viewController.messageComposeDelegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: ChallengeNonUserView

        init(parent: ChallengeNonUserView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            parent.isPresented = false
        }
    }
}
