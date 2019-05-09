//
//  AlgorithmGenerator.swift
//  CubeTimer
//
//  Created by Rapsodo-Mobil-2 on 20.03.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import Foundation

struct Move {
    var notation: Notation
    var direction: Direction
    
    func toString() -> String {
        var str = ""
        switch direction {
        case .Straight:
            str = "\(notation)"
            break
        case .Double:
            str = "\(notation)2"
            break
        case .Reverse:
            str = "\(notation)'"
            break
        }
        
        return str
    }
}

enum Direction: Int {
    case Straight
    case Reverse
    case Double
}

enum Notation: Int {
    case F
    case R
    case L
    case U
    case D
    case B
}


class AlgorithmGenerator {
    
    static func generateAlg() -> String{
        
        var alg = ""
        let length = Int.random(in: 15...20)
        var mv = Move(notation: Notation(rawValue: Int.random(in: 0...5))!, direction: Direction(rawValue: Int.random(in: 0...2))!)
        for _ in 0...length {
            alg = "\(alg)\(mv.toString())  "
            mv = getNextMove(move: mv)
        }
        return alg
    }
    
    private static func getNextMove(move: Move) -> Move {
        
        var next = Move(notation: Notation(rawValue: Int.random(in: 0...5))!, direction: Direction(rawValue: Int.random(in: 0...2))!)
        while !isLegal(before: move, next: next) {
            next = Move(notation: Notation(rawValue: Int.random(in: 0...5))!, direction: Direction(rawValue: Int.random(in: 0...2))!)
        }
        return next
    }
    
    private static func isLegal(before: Move, next: Move) -> Bool {
        let condition1 = before.notation != next.notation
        var condition2 = true
        switch before.notation {
        case .F:
            condition2 = next.notation != .B
            break
        case .B:
            condition2 = next.notation != .F
            break
        case .R:
            condition2 = next.notation != .L
            break
        case .L:
            condition2 = next.notation != .R
            break
        case .D:
            condition2 = next.notation != .U
            break
        case .U:
            condition2 = next.notation != .D
            break
        
        }
        return condition1 && condition2
    }
}

