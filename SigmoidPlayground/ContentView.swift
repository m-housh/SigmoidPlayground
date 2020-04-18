//
//  ContentView.swift
//  SigmoidPlayground
//
//  Created by Michael Housh on 4/17/20.
//  Copyright © 2020 Michael Housh. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {

    let frameHeight: CGFloat
    let frameWidth: CGFloat

    let extraFlashlightOffset: CGFloat = 25
    let flashLightYOffset: CGFloat = -15

    @State private var minString: String = "50"
    @State private var maxString: String = "300"

    @State private var budgetOneString: String = "80"
    @State private var budgetTwoString: String = "125"

    init(width: CGFloat = 1000, height: CGFloat = 500) {
        self.frameWidth = width
        self.frameHeight = height
    }

    private func flashlightOffset(for budget: Int) -> CGFloat {
        let min = Int(minString) ?? 50
        let max = Int(maxString) ?? 300
        let range = max - min
        let step = frameWidth / CGFloat(range)
        let distance = budget - min
        return step * CGFloat(distance) + extraFlashlightOffset
    }

    private var v1View: some View {
        VShape(minScale: Int(minString),
               maxScale: Int(maxString),
               customerBudget: Int(budgetOneString),
               contractorBudget: Int(budgetTwoString))
            .fill(LinearGradient(gradient: .init(colors: [.white, .yellow]), startPoint: .bottom, endPoint: .top))
            .opacity(0.7)
            .frame(width: frameWidth, height: frameHeight, alignment: .center)

    }

    private var flashLightView: some View {
        Image(systemName: "flashlight.on.fill")
    }

    private var formView: some View {
        Form {
            Section(header: Text("Minimum Budget Scale")) {
                        TextField("", text: $minString)
            }

            Section(header: Text("Maximum Budget Scale")) {
                TextField("", text: $maxString)
            }
            Section(header: Text("Customer Budget")) {
                TextField("", text: $budgetOneString)
            }
            Section(header: Text("Contractor Budget")) {
                TextField("", text: $budgetTwoString)
            }
        }
    }

    private var sigmoidView: some View {
        VStack {
            HStack {
               LabelsY()
                   .frame(width: 50, height: frameHeight, alignment: .trailing)

               SigmoidView(width: frameWidth, height: frameHeight)
                   .overlay(v1View)
           }

           ZStack {
               LabelsX(min: Int(minString) ?? 50, max: Int(maxString) ?? 300)
                   .frame(width: frameWidth, height: 50)

               flashLightView
                   .frame(width: frameWidth, alignment: .topLeading)
                   .offset(x: flashlightOffset(for: Int(budgetOneString) ?? 80), y: flashLightYOffset)

               flashLightView
                   .frame(width: frameWidth, alignment: .topLeading)
                   .offset(x: flashlightOffset(for: Int(budgetTwoString) ?? 120), y: flashLightYOffset)
           }
        }
    }


    var body: some View {
        NavigationView {
            HStack(spacing: 40) {
                sigmoidView
                formView
                    .frame(maxWidth: 300)
                    .offset(x: 0, y: 150)
            }
            .navigationBarTitle("Sigmoid Playground", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LabelsX: View {

    let min: Int
    let max: Int

    var step: Int {
        (max - min) / (Sigmoid.sigmoidNums.count + 1)
    }

    var labels: [Int] {
        var labels: [Int] = []
        for index in 0...Sigmoid.sigmoidNums.count {
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

    func path(in rect: CGRect) -> Path {
        var path = Path()
        drawV1(path: &path, in: rect)
        drawV2(path: &path, in: rect)
        return path
    }
}

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
                .stroke(style: StrokeStyle(lineWidth: 3))
                .frame(width: frameWidth, height: frameHeight)
                .foregroundColor(.primary)

            GridX()
                .stroke(style: StrokeStyle(dash: [5]))
                .frame(width: frameWidth, height: frameHeight)
                .foregroundColor(.gray)
                .opacity(0.5)

            GridY()
                .stroke(style: StrokeStyle(dash: [5]))
                .frame(width: frameWidth, height: frameHeight)
                .foregroundColor(.gray)
                .opacity(0.5)
        }
        .background(SigmoidBackground().frame(width: frameWidth, height: frameHeight))
    }
}

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

struct Sigmoid: Shape {

    static var sigmoidNums: [CGFloat] {
        let sigmoid = (-6...6).map {
            1 / (1 + exp(Double($0) * -1))
        }

        return sigmoid.map { CGFloat($0) }
    }

    func drawSigmoid(path: inout Path, in rect: CGRect) {
        let stepX = rect.maxX / CGFloat(Self.sigmoidNums.count - 1)
        path.move(to: .init(x: 0, y: rect.maxY))
        for (index, num) in Self.sigmoidNums.enumerated() {
            let y = rect.maxY - (rect.maxY * num)
            path.addLine(to: .init(x: CGFloat(index) * stepX, y: y))
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        drawSigmoid(path: &path, in: rect)
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
