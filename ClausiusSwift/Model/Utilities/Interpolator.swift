//
//  Interpolator.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/23/22.
//

import Foundation

enum InterpolatorError : Error {
    case indexOutOfBounds
}

class Interpolator {

    static func interpolate1D(with array1D: [Double], and weight: Double, at index: Int) -> Double {
        let low = array1D[index - 1]
        let high = array1D[index]

        return low + weight * (high - low)
    }

    static func interpolate1D(array1D: [Double], xArray: [Double], xValue: Double) -> Double {
        // find xIndex
        var xIndex = 0

        for x in xArray {
            if fabs(xValue - x) < Double.ulpOfOne {
                break
            } else if x > xValue {
                xIndex -= 1
                break
            }
            xIndex += 1
        }

        let f = array1D[xIndex] + ((xValue - xArray[xIndex]) / (xArray[xIndex + 1] - xArray[xIndex])) * (array1D[xIndex + 1] - array1D[xIndex])

        return f
    }

    static func interpolate2D(array2D: [[Double]],
                              xArray: [Double],
                              yArray: [Double],
                              xValue: Double,
                              yValue: Double) -> Double {

        // find xIndex
        var xIndex = 0

        for x in xArray {
            if fabs(xValue - x) < Double.ulpOfOne {
                break
            } else if x > xValue {
                xIndex -= 1
                break
            }
            xIndex += 1
        }

        // find yIndex
        var yIndex = 0

        for y in yArray {
            if fabs(yValue - y) < Double.ulpOfOne {
                break
            } else if y > yValue {
                yIndex -= 1
                break
            }
            yIndex += 1
        }

        let f11 = array2D[xIndex][yIndex]
        let f12 = array2D[xIndex][yIndex + 1]
        let f21 = array2D[xIndex + 1][yIndex]
        let f22 = array2D[xIndex + 1][yIndex + 1]

        let p11 = f11 * (xArray[xIndex + 1] - xValue) * (yArray[yIndex + 1] - yValue)
        let p21 = f21 * (xValue - xArray[xIndex])     * (yArray[yIndex + 1] - yValue)
        let p12 = f12 * (xArray[xIndex + 1] - xValue) * (yValue - yArray[yIndex])
        let p22 = f22 * (xValue - xArray[xIndex])     * (yValue - yArray[yIndex])

        let f = (p11 + p12 + p21 + p22) / ((xArray[xIndex + 1] - xArray[xIndex]) * (yArray[yIndex + 1] - yArray[yIndex]))

        return f
    }

    static func interpolateY2D(array2D: [[Double]],
                               xArray: [Double],
                               yArray: [Double],
                               xValue: Double,
                               array2DValue: Double) throws -> Double {

        // find xIndex
        var xIndex = 0

        for x in xArray {
            if fabs(xValue - x) < Double.ulpOfOne {
                break
            } else if x > xValue {
                xIndex -= 1
                break
            }
            xIndex += 1
        }

        let xWeight = (xValue - xArray[xIndex]) / (xArray[xIndex + 1] - xArray[xIndex])

        // find yIndex
        var yIndex = 0

        let zArray1 = array2D[xIndex]
        let zArray2 = array2D[xIndex + 1]

        for _ in yArray {
            let z1 = zArray1[yIndex] + xWeight * (zArray2[yIndex] - zArray1[yIndex])
            let z2 = zArray1[yIndex + 1] + xWeight * (zArray2[yIndex + 1] - zArray1[yIndex + 1])
            let cond1 = z1 > z2 && z1 >= array2DValue && array2DValue >= z2
            let cond2 = z1 < z2 && z1 <= array2DValue && array2DValue <= z2
            if cond1 || cond2 {
                break
            }
            yIndex += 1
            if yIndex + 1 >= zArray1.count || yIndex + 1 >= zArray2.count {
                throw InterpolatorError.indexOutOfBounds
            }
        }

        let x1 = xArray[xIndex]
        let x2 = xArray[xIndex + 1]
        let y1 = yArray[yIndex]
        let y2 = yArray[yIndex + 1]
        let f11 = zArray1[yIndex]
        let f12 = zArray1[yIndex + 1]
        let f21 = zArray2[yIndex]
        let f22 = zArray2[yIndex + 1]

        let a00 = ((x2 * y2 * f11) - (x2 * y1 * f12) - (x1 * y2 * f21) + (x1 * y1 * f22)) / ((x2 - x1) * (y2 - y1))
        let a10 = ((-y2 * f11) + (y1 * f12) + (y2 * f21) - (y1 * f22)) / ((x2 - x1) * (y2 - y1))
        let a01 = ((-x2 * f11) + (x2 * f12) + (x1 * f21) - (x1 * f22)) / ((x2 - x1) * (y2 - y1))
        let a11 = (f11 - f12 - f21 + f22) / ((x2 - x1) * (y2 - y1))

        let a = a00 + a10 * xValue
        let b = a01
        let c = a11 * xValue

        let y = (array2DValue - a) / (b + c)

        return y
    }

}
