import CoreFoundation

private protocol Syntax {
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
}

private struct B: Syntax {
  let v: Int
  let w: Int
  let q: Int
  let r: Int

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

  mutating func insert(n: any Syntax) -> SyntaxID {
    store.append(n)
    return .init(store.count - 1)
  }

}

func testInsertionAndOneByOnePatternMatchingNaiveEverytingInOneWithExistentials() -> Int {
  var p = Program()

  var num: UInt = 0

  var list: [SyntaxID] = []
  var sum = 0
  for _ in 0..<10_000_00 {
    num += 2432
    num *= 39
    num %= 1_000_001

    if num % 3 == 0 {
      list.append(
        p.insert(n: A(v: 0, w: 1, q: 2, r: 3, t: 4, u: 5, i: 6, o: 7, p: 8, a: 9, s: 10, d: 11))
      )
    } else if num % 3 == 1 {
      list.append(p.insert(n: B(v: Int(num), w: 1, q: 2, r: 3)))
    } else {
      list.append(
        p.insert(
          n: C(
            x: Int(num), y: Int(num + 1), z: Int(num + 2), w: Int(num + 3), q: Int(num + 4),
            r: Int(num + 5), t: Int(num + 6), u: Int(num + 7), i: Int(num + 8), o: Int(num + 9))
        ))
    }
  }

  for _ in 0..<10_000_00 {
    num += 2432
    num *= 39
    num %= 1_000_001

    switch p[list[Int(num) % list.count]] {
    case let a as A:
      sum += a.v
    case let b as B:
      sum += b.v
    case let c as C:
      sum += c.x + c.y + c.z + c.w + c.q + c.r + c.t + c.u + c.i + c.o
    default:
      fatalError()
    }
  }

  return sum + p.store.count
}
