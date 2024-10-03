func assertEqual<T: Equatable>(_ a: T, _ b: T, file: StaticString = #file, line: UInt = #line) {
  precondition(a == b, file: file, line: line)
}

/// dummy function, todo eliminate
func printTimeElapsedWhenRunningCode(title: String, runs: Int = 1, _ code: () -> Void) {
  code()
}