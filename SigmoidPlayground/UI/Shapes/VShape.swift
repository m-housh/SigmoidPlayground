//
//  VShape.swift
//  SigmoidPlayground
//
//  Created by Michael Housh on 4/18/20.
//  Copyright © 2020 Michael Housh. All rights reserved.
//

import Foundation
import SwiftUI

struct VShape: Shape {

    private let min: Int
    private let max: Int

    private let v1Guess: Int
    private let v2Guess: Int

    init(
        minScale: Int? = nil,
        maxScale: Int? = nil,
        customerBudget: Int? = nil,
        contractorBudget: Int? = nil
    ) {
        self.min = minScale ?? 50
        self.max = maxScale ?? 300
        self.v1Guess = customerBudget ?? 90
        self.v2Guess = contractorBudget ?? 225
    }

    private func centerV(guess: Int, in rect: CGRect) -> CGFloat {
        let range = max - min
        let step = rect.maxX / CGFloat(range)
        let distance = CGFloat(guess - min)
        return step * distance
    }

    private func drawV1(path: inout Path, in rect: CGRect) {
        let offset = rect.maxX / CGFloat(Sigmoid.sigmoidNums.count)
        let center = centerV(guess: v1Guess, in: rect)
        path.move(to: .init(x: center, y: rect.maxY))
        path.addLine(to: .init(x: center - offset, y: 0))
        path.addLine(to: .init(x: center + offset, y: 0))
        path.addLine(to: .init(x: center, y: rect.maxY))
    }

    private func drawV2(path: inout Path, in rect: CGRect) {
        let offset = rect.maxX / CGFloat(Sigmoid.sigmoidNums.count)
        let center = centerV(guess: v2Guess, in: rect)
        path.move(to: .init(x: center, y: rect.maxY))
        path.addLine(to: .init(x: center - offset, y: 0))
        path.addLine(to: .init(x: center + offset, y: 0))
        path.addLine(to: .init(x: center, y: rect.maxY))
    }

    // Draw the path
    func path(in rect: CGRect) -> Path {
        var path = Path()
        drawV1(path: &path, in: rect)
        drawV2(path: &path, in: rect)
        return path
    }
}
