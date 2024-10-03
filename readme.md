# Implementation strategies for an efficient polymorphic entity store
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
