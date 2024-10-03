private protocol Syntax {
  static func updateSpecificStore<T>(from: inout DifferentStores, run: (inout [Self]) -> T) -> T
  static func specificStore(from: DifferentStores) -> [Self]
  static var syntaxType: SyntaxType { get }
}

extension Syntax {
  fileprivate typealias ID = SyntaxID<Self>
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

  public static func specificStore(from ds: DifferentStores) -> [A] {
    return ds.a
  }

  public static func updateSpecificStore<T>(
    from ds: inout DifferentStores, run: (inout [A]) -> T
  )
    -> T
  {
    return run(&ds.a)
  }

  static let syntaxType: SyntaxType = .a
}

private struct B: Syntax {
  let v: Int
  let w: Int
  let q: Int
  let r: Int

  public static func specificStore(from ds: DifferentStores) -> [B] {
    return ds.b
  }

  public static func updateSpecificStore<T>(
    from ds: inout DifferentStores, run: (inout [B]) -> T
  )
    -> T
  {
    return run(&ds.b)
  }

  static let syntaxType: SyntaxType = .b
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

  public static func specificStore(from ds: DifferentStores) -> [C] {
    return ds.c
  }

  public static func updateSpecificStore<T>(
    from ds: inout DifferentStores, run: (inout [C]) -> T
  )
    -> T
  {
    return run(&ds.c)
  }

  static let syntaxType: SyntaxType = .c
}

private struct SyntaxID<T: Syntax> {
  var raw: Int
  init(_ raw: Int) { self.raw = raw }
}

private struct DifferentStores {
  var a: [A] = []
  var b: [B] = []
  var c: [C] = []
}

private struct Program {
  var differentStores = DifferentStores()

  var syntaxInfo: [SyntaxInfo] = []

  init() {}

  // subscript<T: Syntax>(id: T.ID) -> T {
  //   T.specificStore(from: self)[id.raw]
  // }

  typealias ID = Int

  mutating func insert<T: Syntax>(n: T) -> ID {
    return T.updateSpecificStore(from: &differentStores) {
      $0.append(n)
      let localId = UInt32($0.count - 1)
      syntaxInfo.append(.init(privateId: localId, type: T.syntaxType))

      return syntaxInfo.count - 1
    }
  }


  subscript(id: ID) -> any Syntax {
    let info = syntaxInfo[id]

    switch info.type {
    case .a:
      return differentStores.a[Int(info.privateId)]
    case .b:
      return differentStores.b[Int(info.privateId)]
    case .c:
      return differentStores.c[Int(info.privateId)]
    }
  }
}

private enum SyntaxType {
  case a
  case b
  case c
}

private struct SyntaxInfo {
  let privateId: UInt32
  let type: SyntaxType
}

private struct AnySyntaxID {
  let raw: Int
}

func patternMatchAndMapIdUpcastingToAny() -> Int {
  var p = Program()

  var num: UInt = 0

  var list: [Program.ID] = []
  var sum = 0

  for _ in 0..<10_000_00 {
    num += 2432
    num *= 39
    num %= 1_000_001

    if num % 3 == 0 {
      list.append(

        p.insert(
          n: A(v: 0, w: 1, q: 2, r: 3, t: 4, u: 5, i: 6, o: 7, p: 8, a: 9, s: 10, d: 11)))
    } else if num % 3 == 1 {
      list.append(p.insert(n: B(v: Int(num), w: 1, q: 2, r: 3)))
    } else {
      list.append(
        p.insert(
          n: C(
            x: Int(num), y: Int(num + 1), z: Int(num + 2), w: Int(num + 3), q: Int(num + 4),
            r: Int(num + 5), t: Int(num + 6), u: Int(num + 7), i: Int(num + 8),
            o: Int(num + 9))
        )
      )
    }
  }

  for _ in 0..<10_000_00 {
    num += 2432
    num *= 39
    num %= 1_000_001


    let anySyntax = p[list[Int(num) % list.count]]

    switch anySyntax {
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

  return sum + p.differentStores.a.count + p.differentStores.b.count + p.differentStores.c.count
}
