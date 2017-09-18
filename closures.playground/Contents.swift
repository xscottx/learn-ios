//: Playground - noun: a place where people can play

import UIKit

func calculator (n1: Int, n2: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(n1, n2)
}

func add (n1: Int, n2: Int) -> Int {
    return n1 + n2
}

func multiply (n1: Int, n2: Int) -> Int {
    return n1 * n2
}

calculator(n1: 1, n2: 2, operation: multiply)

calculator(n1: 1, n2: 2, operation: { (n1: Int, n2: Int) -> Int in
    return n1 * n2
})

//let result = calculator(n1: 1, n2: 2, operation: {$0 * $1})
let result = calculator(n1: 1, n2: 2) {$0 * $1}
print(result)

let array = [6,2,3,9,4,1]

func addOne (n1: Int) -> Int {
    return n1 + 1
}

array.map(addOne)

array.map({(n1: Int) -> Int in
    return n1 + 1
})

array.map({(n1: Int) -> Int in
    n1 + 1
})

array.map({(n1) -> Int in
    n1 + 1
})

array.map({$0 + 1})
array.map{$0 + 1}

let newArray = array.map{"\($0 + 1)"}
print(newArray)



