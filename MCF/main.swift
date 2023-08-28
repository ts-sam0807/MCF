//
//  main.swift
//  MCF
//
//  Created by Ts SaM on 28/8/2023.
//
//import Foundation

class Queue<T> {
    private var array: [T] = []
    
    func enqueue(_ element: T) {
        array.append(element)
    }
    
    func dequeue() -> T? {
        if !isEmpty() {
            return array.removeFirst()
        }
        return nil
    }
    
    func isEmpty() -> Bool {
        return array.isEmpty
    }
}

struct Edge {
    var from: Int
    var to: Int
    var cost: Int
}

struct Pipe {
    let from: Int
    let to: Int
    let cost: Int
}

class Graph {
    var vertices: Int
    var edges: [Edge]
    var parent: [Int]
    
    init(vertices: Int, edges: [Edge]) {
        self.vertices = vertices
        self.edges = edges
        parent = Array(0...vertices)
    }
    
    func find(_ x: Int) -> Int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    
    func union(_ x: Int, _ y: Int) {
        let px = find(x)
        let py = find(y)
        parent[py] = px
    }
    
    func minimumCost() -> Int {
        var totalCost = 0
        
        edges.sort { $0.cost < $1.cost }
        
        for edge in edges {
            let fromParent = find(edge.from)
            let toParent = find(edge.to)
            
            if fromParent != toParent {
                union(edge.from, edge.to)
                totalCost += edge.cost
            }
        }
        
        return totalCost
    }
}

//func solution() {
//    let input = readLine()!.split(separator: " ").map { Int($0)! }
//    let N = input[0], M = input[1], D = input[2]
//
//    var edges = [Edge]()
//    var initialPlanCost = 0
//
//    for _ in 0..<M {
//        let pipeInfo = readLine()!.split(separator: " ").map { Int($0)! }
//        let from = pipeInfo[0]
//        let to = pipeInfo[1]
//        let cost = max(0, pipeInfo[2] - D)
//
//        edges.append(Edge(from: from, to: to, cost: cost))
//
//        if from != 1 {
//            initialPlanCost += cost
//        }
//    }
//
//    edges[0].cost = max(0, edges[0].cost)
//    let graph = Graph(vertices: N, edges: edges)
//
//    let minimumMSTCost = graph.minimumCost()
//
//    print(minimumMSTCost + initialPlanCost)
//}
//
//solution()


func minimumDaysToOptimizePlan(N: Int, M: Int, D: Int, pipes: [Pipe]) -> Int {
    var graph = [Int: [Pipe]]()
    for pipe in pipes {
        graph[pipe.from, default: []].append(pipe)
        graph[pipe.to, default: []].append(pipe)
    }
    
    var activePipes = Set<Int>()
    var totalCost = 0
    for i in 0..<N-1 {
        activePipes.insert(i)
        totalCost += pipes[i].cost
    }
    
    var minDays = Int.max
    for i in 0..<N-1 {
        let deactivatedPipe = pipes[i]
        let enhancedCost = max(0, deactivatedPipe.cost - D) // *
        // From
        for activatedPipe in graph[deactivatedPipe.from, default: []] {
            if activePipes.contains(activatedPipe.from) && activatedPipe.to != deactivatedPipe.to {
                let newCost = totalCost - deactivatedPipe.cost + enhancedCost + activatedPipe.cost // *
                minDays = min(minDays, newCost - totalCost)
            }
        }
        // To
        for activatedPipe in graph[deactivatedPipe.to, default: []] {
            if activePipes.contains(activatedPipe.from) && activatedPipe.to != deactivatedPipe.from {
                let newCost = totalCost - deactivatedPipe.cost + enhancedCost + activatedPipe.cost // *
                minDays = min(minDays, newCost - totalCost)
            }
        }
    }
    
    return minDays == Int.max ? 0 : minDays
}

let inputLine1 = readLine()!.split(separator: " ").map { Int($0)! }
let N = inputLine1[0]
let M = inputLine1[1]
let D = inputLine1[2]

var pipes = [Pipe]()
for _ in 0..<M {
    let pipeInfo = readLine()!.split(separator: " ").map { Int($0)! }
    pipes.append(Pipe(from: pipeInfo[0], to: pipeInfo[1], cost: pipeInfo[2]))
}

let result = minimumDaysToOptimizePlan(N: N, M: M, D: D, pipes: pipes)


//4 4 0
//1 2 1
//2 3 2
//3 4 1
//4 1 1
//
//5 6 2
//1 2 5
//2 3 5
//1 4 5
//4 5 5
//1 3 1
//1 5 1



print(result)
