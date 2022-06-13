//
//  SpaceController.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 6/4/22.
//

import CoreGraphics
import Foundation

extension CGPoint {

    func distance(to point: CGPoint) -> CGFloat {
        return CGFloat(sqrtf(powf(Float(self.x - point.x), 2.0) + powf(Float(self.y - point.y), 2.0)))
    }

}

class SpaceController {

#if targetEnvironment(macCatalyst)
    private let numPoints: Int = 15
#else
    private let numPoints: Int = 5
#endif

#if targetEnvironment(macCatalyst)
    private let maxDiff: CGFloat = 20.0
#else
    private let maxDiff: CGFloat = 30.0
#endif

    var enableFineTuning = true

    private var points: [CGPoint] = []

    private var shouldFineTune = false

    private var lastFineTuneLocation: CGPoint?

    func fineTunedWithLatest(point: CGPoint) -> CGPoint {
        if enableFineTuning {
            addLatest(point: point)

            if points.count == numPoints {
                if largestDistance() < maxDiff || shouldFineTune {
                    shouldFineTune = true

                    lastFineTuneLocation = fineTunedPoint()

                    return lastFineTuneLocation!
                }
            }
        }

        return point
    }

    private func fineTunedPoint() -> CGPoint {

        let lastPoint = points[numPoints - 2]
        let thisPoint = points[numPoints - 1]

        let actualDeltaX = thisPoint.x - lastPoint.x
        let actualDeltaY = thisPoint.y - lastPoint.y

        let deltaX = 0.2 * actualDeltaX
        let deltaY = 0.2 * actualDeltaY

        let lastFineTuneLoc = lastFineTuneLocation ?? lastPoint

        let newPointX = lastFineTuneLoc.x + deltaX
        let newPointY = lastFineTuneLoc.y + deltaY

        return CGPoint(x: newPointX, y: newPointY)

    }

    private func addLatest(point: CGPoint) {
        if points.count == numPoints {
            points.remove(at: 0)
        }

        points.append(point)
    }

    private func largestDistance() -> CGFloat {
        var highestDiff: CGFloat = 0.0

        for i in 0..<numPoints {
            for j in 0..<numPoints {
                let p1 = points[i]
                let p2 = points[j]

                let diff = p1.distance(to: p2)
                highestDiff = max(highestDiff, diff)
            }
        }

        return highestDiff
    }

    func reset() {
        points = []
        shouldFineTune = false
        lastFineTuneLocation = nil
    }

}
