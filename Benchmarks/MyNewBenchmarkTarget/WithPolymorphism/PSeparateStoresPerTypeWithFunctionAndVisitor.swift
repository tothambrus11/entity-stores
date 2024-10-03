private protocol Syntax {
  func getProductWith(n: Int) -> Int

  static func updateSpecificStore<T>(from: inout Program, run: (inout [Self]) -> T) -> T
  static func specificStore(from: Program) -> [Self]
}

extension Syntax {
  fileprivate typealias ID = SyntaxID<Self>
}

private struct A: Syntax {
  static var path: WritableKeyPath<Program, [Self]> = \.a
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

  public static func specificStore(from program: Program) -> [A] {
    return program.a
  }

  public static func updateSpecificStore<T>(
    from program: inout Program, run: (inout [A]) -> T
  )
    -> T
  {
    return run(&program.a)
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

  public static func specificStore(from program: Program) -> [B] {
    return program.b
  }

  public static func updateSpecificStore<T>(
    from program: inout Program, run: (inout [B]) -> T
  )
    -> T
  {
    return run(&program.b)
  }
}

private struct C: Syntax {
  static var path: WritableKeyPath<Program, [Self]> = \.c
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

  public static func specificStore(from program: Program) -> [C] {
    return program.c
  }

  public static func updateSpecificStore<T>(
    from program: inout Program, run: (inout [C]) -> T
  )
    -> T
  {
    return run(&program.c)
  }
}

private struct SyntaxID<T: Syntax> {
  var raw: Int
  init(_ raw: Int) { self.raw = raw }
}

private protocol VisitorProtocol {
  associatedtype Result
  func visit(_ o: some Syntax) -> Result
}

private struct MyVisitor: VisitorProtocol {
  let payload: Int

  func visit(_ o: some Syntax) -> Int {
    o.getProductWith(n: payload)
  }
}

private struct MyBigVisitor: VisitorProtocol {
  let payload: [Int]

  func visit(_ o: some Syntax) -> Int {
    o.getProductWith(n: payload.reduce(0, +))
  }
}
private struct Program {

  var a: [A] = []
  var b: [B] = []
  var c: [C] = []

  init() {}

  // monomorphisable
  subscript<T: Syntax>(id: T.ID) -> T {
    T.specificStore(from: self)[id.raw]
  }

  mutating func insert<T: Syntax>(_ item: T) -> T.ID {
    return T.updateSpecificStore(from: &self) {
      $0.append(item)
      return .init($0.count - 1)
    }
  }

  // polymorphic                                                                                                                    ^^^^^^^^^
  subscript(_ id: AnySyntaxID) -> (any Syntax) {
    switch id {
    case .a(let id):
      return a[id.raw]
    case .b(let id):
      return b[id.raw]
    case .c(let id):
      return c[id.raw]
    }
  }

  func visit<V: VisitorProtocol>(better id: AnySyntaxID, visitor: V) -> V.Result {
    switch id {
    case .a(let id):
      return visitor.visit(a[id.raw])
    case .b(let id):
      return visitor.visit(b[id.raw])
    case .c(let id):
      return visitor.visit(c[id.raw])
    }
  }

  mutating func insertAny(_ syntax: (any Syntax)) -> AnySyntaxID {
    switch syntax {
    case let a as A:
      return .a(insert(a))
    case let b as B:
      return .b(insert(b))
    case let c as C:
      return .c(insert(c))
    default:
      fatalError()
    }
  }

}

private enum AnySyntaxID {
  case a(SyntaxID<A>)
  case b(SyntaxID<B>)
  case c(SyntaxID<C>)

  var raw: Int {
    switch self {
    case .a(let id):
      return id.raw
    case .b(let id):
      return id.raw
    case .c(let id):
      return id.raw
    }
  }
}

  func pSeparateStoresPerTypeWithFunctionAndVisitorTestTestPolymorphicMethodDispatch() {
    var p = Program()

    var num: UInt = 0

    var list: [AnySyntaxID] = []
    var sum = 0

  
    for _ in 0..<100000 {
      num += 2432
      num *= 39
      num %= 1_000_001

      if num % 3 == 0 {
        list.append(
          .a(
            p.insert(
              A(v: 0, w: 1, q: 2, r: 3, t: 4, u: 5, i: 6, o: 7, p: 8, a: 9, s: 10, d: 11))))
      } else if num % 3 == 1 {
        list.append(.b(p.insert(B(v: Int(num), w: 1, q: 2, r: 3))))
      } else {
        list.append(
          .c(
            p.insert(
              C(
                x: Int(num), y: Int(num + 1), z: Int(num + 2), w: Int(num + 3), q: Int(num + 4),
                r: Int(num + 5), t: Int(num + 6), u: Int(num + 7), i: Int(num + 8),
                o: Int(num + 9))
            )))
      }
    }

    for _ in 0..<100000 {
      num += 2432
      num *= 39
      num %= 1_000_001

      sum += p.visit(
        better: list[Int(num) % list.count], visitor: MyVisitor(payload: Int(num) % 100))
    }
  
    // assertEqual(p.a.count + p.b.count + p.c.count, 100000)
    // assertEqual(sum, 1_130_775_979_938_052_742)
  }

  func pSeparateStoresPerTypeWithFunctionAndVisitorTestTestPolymorphicMethodDispatchBigPayload() {
    var p = Program()

    var num: UInt = 0

    var list: [AnySyntaxID] = []
    var sum = 0
    
    for _ in 0..<100000 {
      num += 2432
      num *= 39
      num %= 1_000_001

      if num % 3 == 0 {
        list.append(
          .a(
            p.insert(
              A(v: 0, w: 1, q: 2, r: 3, t: 4, u: 5, i: 6, o: 7, p: 8, a: 9, s: 10, d: 11))))
      } else if num % 3 == 1 {
        list.append(.b(p.insert(B(v: Int(num), w: 1, q: 2, r: 3))))
      } else {
        list.append(
          .c(
            p.insert(
              C(
                x: Int(num), y: Int(num + 1), z: Int(num + 2), w: Int(num + 3), q: Int(num + 4),
                r: Int(num + 5), t: Int(num + 6), u: Int(num + 7), i: Int(num + 8),
                o: Int(num + 9))
            )))
      }
    }

    for _ in 0..<100000 {
      num += 2432
      num *= 39
      num %= 1_000_001

      let a: Int = Int(num) % 100
      sum += p.visit(
        better: list[Int(num) % list.count],
        visitor: MyBigVisitor(payload: [
          a, a + 1, -a + 2, a + 3, a + 4, a + 5, -a + 6, a + 7, a + 8, -a + 9,
        ]))
    }
  
  }
