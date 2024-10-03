private protocol Syntax {
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

private struct Program {

  var a: [A] = []
  var b: [B] = []
  var c: [C] = []

  init() {}

  subscript<T: Syntax>(id: T.ID) -> T {
    T.specificStore(from: self)[id.raw]
  }

  mutating func insert<T: Syntax>(n: T) -> T.ID {
    return T.updateSpecificStore(from: &self) {
      $0.append(n)
      return .init($0.count - 1)
    }
  }
}

private enum AnySyntaxID {
  case a(SyntaxID<A>)
  case b(SyntaxID<B>)
  case c(SyntaxID<C>)
}

func separateStoresPerTypeIdentifiedByFunctionTestInsertionAndOneByOnePatternMatching() -> Int {
  var p = Program()

  var num: UInt = 0

  var list: [AnySyntaxID] = []
  var sum = 0

  for _ in 0..<10_000_00 {
    num += 2432
    num *= 39
    num %= 1_000_001

    if num % 3 == 0 {
      list.append(
        .a(
          p.insert(
            n: A(v: 0, w: 1, q: 2, r: 3, t: 4, u: 5, i: 6, o: 7, p: 8, a: 9, s: 10, d: 11))))
    } else if num % 3 == 1 {
      list.append(.b(p.insert(n: B(v: Int(num), w: 1, q: 2, r: 3))))
    } else {
      list.append(
        .c(
          p.insert(
            n: C(
              x: Int(num), y: Int(num + 1), z: Int(num + 2), w: Int(num + 3), q: Int(num + 4),
              r: Int(num + 5), t: Int(num + 6), u: Int(num + 7), i: Int(num + 8),
              o: Int(num + 9))
          )))
    }
  }

  for _ in 0..<10_000_00 {
    num += 2432
    num *= 39
    num %= 1_000_001

    switch list[Int(num) % list.count] {
    case .a(let id):
      sum += p[id].v
    case .b(let id):
      sum += p[id].v
    case .c(let id):
      let e = p[id]
      sum += e.x + e.y + e.z + e.w + e.q + e.r + e.t + e.u + e.i + e.o
    }

  }
  
  return sum + p.a.count + p.b.count + p.c.count
}
