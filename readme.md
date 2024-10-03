# Exploring Implementation Strategies for Heterogeneous Entity Stores
## Introduction
TODO

## How to run the benchmarks
Emitting the raw metrics (nice & detailed):
```
swift package benchmark
```

Emitting in JMH format (can be visualized using [JMH Visualizer](https://jmh.morethan.io/)):
```
swift package --allow-writing-to-package-directory benchmark --format jmh
```

Filtering benchmarks:
```
home/ambrus/Downloads/swift-6.0.1-RELEASE-debian12/usr/bin/swift package --allow-writing-to-package-directory benchmark --format jmh --filter InsertAndPatternMatchAll.*
```

# Design Option Tree
- Do we want to change the type of an item in the store while preserving its global id?
  - No
    - `enum AnyId{ a(A.ID); b(B.ID); c(C.ID) }`
    - `struct AnyId{ raw: Int; kind: NodeProtocol.Type }` (current approach in hc)
  - Yes
    - `struct AnyId{ raw: Int }` + layer of indirection mapping global IDs to local ids and their kinds
- Do we want to remove items from the store?
    - Do we want this to keep the IDs of other items stable (not invalidate them)?
      - Yes
  - Solutions:
  - TODO research stable data structures, mentioned in meeting 2024-10-03
    - Do we want to actually free up their space, or just conceptually make them not present?
- ...