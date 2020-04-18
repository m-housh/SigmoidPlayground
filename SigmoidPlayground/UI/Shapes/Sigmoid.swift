//
//  Sigmoid.swift
//  SigmoidPlayground
//
//  Created by Michael Housh on 4/18/20.
//  Copyright © 2020 Michael Housh. All rights reserved.
//

import Foundation
import SwiftUI

struct Sigmoid: Shape {

    static var sigmoidNums: [CGFloat] {
        let sigmoid = (-6...6).map {
            1 / (1 + exp(Double($0) * -1))
        }

        return sigmoid.map { CGFloat($0) }
    }

    private func drawSigmoid(path: inout Path, in rect: CGRect) {
        let stepX = rect.maxX / CGFloat(Self.sigmoidNums.count - 1)
        path.move(to: .init(x: 0, y: rect.maxY))
        for (index, num) in Self.sigmoidNums.enumerated() {
            let y = rect.maxY - (rect.maxY * num)
            path.addLine(to: .init(x: CGFloat(index) * stepX, y: y))
        }
    }

    // Draw the path.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        drawSigmoid(path: &path, in: rect)
        return path
    }
}
