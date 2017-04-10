import PackageDescription

let package = Package(
    name: "Users",
    dependencies: [
        .Package(url:"https://github.com/GeminiSolutions/DataStore", majorVersion: 0)
    ]
)
