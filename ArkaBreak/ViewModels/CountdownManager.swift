//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier CountdownManager.swift


import Foundation
import Combine
import SwiftUI

final class CountdownManager: ObservableObject {
    @Published var text: String? = nil

    private var countdownValues = ["3", "2", "1", "GO!"]
    private var timer: AnyCancellable?

    func startCountdown(completion: @escaping () -> Void) {
        var index = 0
        text = countdownValues[index]

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                index += 1

                if index < self.countdownValues.count {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.text = self.countdownValues[index]
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.text = nil
                    }
                    self.timer?.cancel()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // délai pour laisser "GO!" visible
                        completion()
                    }
                }
            }
    }

    func cancel() {
        timer?.cancel()
        text = nil
    }
}
