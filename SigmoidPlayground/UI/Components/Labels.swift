//
//  Labels.swift
//  SigmoidPlayground
//
//  Created by Michael Housh on 4/18/20.
//  Copyright © 2020 Michael Housh. All rights reserved.
//

import Foundation
import SwiftUI

struct LabelsX: View {

    let min: Int
    let max: Int

    var step: Int {
        (max - min) / (Sigmoid.sigmoidNums.count)
    }

    var labels: [Int] {
        var labels: [Int] = []
        for index in 0..<Sigmoid.sigmoidNums.count {
            labels.append(index == 0 ? min : (index * step) + min)
        }
        return labels
    }

    var body: some View {
        HStack {
            ForEach(labels, id: \.self) { label in
                Text("\(label)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct LabelsY: View {

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ForEach((0...10).reversed(), id: \.self) { index in
                    Text("\(index == 10 ? 95 : index * 10)%")
                        .font(.callout)
                        .frame(height: geometry.size.height / 10)
                }
            }
        }
    }
}
