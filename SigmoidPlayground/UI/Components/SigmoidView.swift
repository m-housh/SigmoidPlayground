//
//  SigmoidView.swift
//  SigmoidPlayground
//
//  Created by Michael Housh on 4/18/20.
//  Copyright © 2020 Michael Housh. All rights reserved.
//

import SwiftUI

struct SigmoidView: View {

    let frameHeight: CGFloat
    let frameWidth: CGFloat

    init(width: CGFloat = 300, height: CGFloat = 300) {
        self.frameWidth = width
        self.frameHeight = height
    }

    var body: some View {
        content
    }

    var content: some View {
        ZStack {
            Rectangle()
                .trim(from: 0.5, to: 1)
                .stroke()
                .frame(width: frameWidth, height: frameHeight)
                .foregroundColor(.black)

            Sigmoid()
                .stroke(style: StrokeStyle(lineWidth: 5))
                .frame(width: frameWidth, height: frameHeight)
                .foregroundColor(.primary)

            GridX()
                .stroke(style: StrokeStyle(dash: [10]))
                .frame(width: frameWidth, height: frameHeight)
                .foregroundColor(.gray)
                .opacity(0.5)

            GridY()
                .stroke(style: StrokeStyle(dash: [10]))
                .frame(width: frameWidth, height: frameHeight)
                .foregroundColor(.gray)
                .opacity(0.5)
        }
        .background(SigmoidBackground().frame(width: frameWidth, height: frameHeight))
    }
}

private extension SigmoidView {
    struct SigmoidBackground: View {
        var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Upper 80%
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: geometry.size.width, height: geometry.size.height / 4)

                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(width: geometry.size.width, height: geometry.size.height / 4)

                    Rectangle()
                        .foregroundColor(.red)
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                }
                .opacity(0.5)
            }
        }
    }
}

struct SigmoidView_Previews: PreviewProvider {
    static var previews: some View {
        SigmoidView()
    }
}
