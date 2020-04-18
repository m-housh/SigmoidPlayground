
//
//  Grid.swift
//  SigmoidPlayground
//
//  Created by Michael Housh on 4/18/20.
//  Copyright © 2020 Michael Housh. All rights reserved.
//

import Foundation
import SwiftUI

struct GridX: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let stepX = rect.maxX / CGFloat(Sigmoid.sigmoidNums.count)
        path.move(to: .init(x: 0, y: 0))
        for index in 1..<Sigmoid.sigmoidNums.count {
            let xPoint = CGFloat(index) * stepX
            path.move(to: .init(x: xPoint , y: 0))
            path.addLine(to: .init(x: xPoint, y: rect.maxY))
        }
        return path
    }
}

struct GridY: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let stepY = rect.maxY / 10
        path.move(to: .init(x: 0, y: 0))
        for index in 1..<10 {
            let yPoint = CGFloat(index) * stepY
            path.move(to: .init(x: 0 , y: yPoint))
            path.addLine(to: .init(x: rect.maxX, y: yPoint))
        }
        return path
    }
}
