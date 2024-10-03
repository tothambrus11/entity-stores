import CoreFoundation

private protocol Syntax {
  func getProductWith(n: Int) -> Int
}

extension Syntax {
  fileprivate typealias ID = SyntaxID
}

private struct A: Syntax {
  let v: Int
  let w: Int
  let q: Int
  let r: Int
  let t: Int
  let u: Int
  let i: Int
  let o: Int
  let p: Int
  let a: Int
  let s: Int
  let d: Int

  func getProductWith(n: Int) -> Int {
    return v * w - q * r + t * u - i * o + p * a - s + d * n
  }
}

private struct B: Syntax {
  let v: Int
  let w: Int
  let q: Int
  let r: Int

  func getProductWith(n: Int) -> Int {
    return v * w - q * r + n
  }
}

private struct C: Syntax {
  let x: Int
  let y: Int
  let z: Int
  let w: Int
  let q: Int
  let r: Int
  let t: Int
  let u: Int
  let i: Int
  let o: Int

  func getProductWith(n: Int) -> Int {
    return x * y + z - w * q + r * t + u - i + o * n
  }
}

private struct SyntaxID {
  var raw: Int
  init(_ raw: Int) { self.raw = raw }
}

private struct Program {
  var store: [any Syntax] = []

  init() {}

  subscript(i: SyntaxID) -> any Syntax {
    store[i.raw]
  }

  mutating func insert(_ n: any Syntax) -> SyntaxID {
    store.append(n)
    return .init(store.count - 1)
  }
  mutating func insertAny(_ n: any Syntax) -> SyntaxID {
    store.append(n)
    return .init(store.count - 1)
  }

}

func pNaiveTestTestPolymorphicMethodDispatch() {
    var p = Program()

    var num: UInt = 0

    var list: [SyntaxID] = []
    var sum = 0



    for _ in 0..<100000 {
      num += 2432
      num *= 39
      num %= 1_000_001

      if num % 3 == 0 {
        list.append(
          p.insert(A(v: 0, w: 1, q: 2, r: 3, t: 4, u: 5, i: 6, o: 7, p: 8, a: 9, s: 10, d: 11))
        )
      } else if num % 3 == 1 {
        list.append(p.insert(B(v: Int(num), w: 1, q: 2, r: 3)))
      } else {
        list.append(
          p.insert(
            C(
              x: Int(num), y: Int(num + 1), z: Int(num + 2), w: Int(num + 3), q: Int(num + 4),
              r: Int(num + 5), t: Int(num + 6), u: Int(num + 7), i: Int(num + 8), o: Int(num + 9))
          ))
      }
    }

    for _ in 0..<100000 {
      num += 2432
      num *= 39
      num %= 1_000_001

      sum += p[list[Int(num) % list.count]].getProductWith(n: Int(num) % 100)
    }
  
    // precondition(p.store.count == 100000)
    // precondition(sum == 1130775979938052742)
  }


  
  func pNaiveTestTestPolymorphicInsertion() {
    var num: UInt = 0

    var sum = 0

    var listToInsert: [any Syntax] = []

    for _ in 0..<100000 {
      num += 2432
      num *= 39
      num %= 1_000_001

      if num % 3 == 0 {
        listToInsert.append(
          A(v: 0, w: 1, q: 2, r: 3, t: 4, u: 5, i: 6, o: 7, p: 8, a: 9, s: 10, d: 11))
      } else if num % 3 == 1 {
        listToInsert.append(B(v: Int(num), w: 1, q: 2, r: 3))
      } else {
        listToInsert.append(
          C(
            x: Int(num), y: Int(num + 1), z: Int(num + 2), w: Int(num + 3), q: Int(num + 4),
            r: Int(num + 5), t: Int(num + 6), u: Int(num + 7), i: Int(num + 8), o: Int(num + 9))
        )
      }
    }

    printTimeElapsedWhenRunningCode(title: "dasss naive \t | polymorphic insertion", runs: 10){
      sum = 0
      var p = Program()
      for i in stride(from: listToInsert.count - 1, to: -1, by: -1) {
        sum += p.insertAny(listToInsert[i]).raw
      }
    }
    // precondition(sum == 49999995000000)

}

// do sg like utf8
// might need to
