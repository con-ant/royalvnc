// swift-tools-version: 6.0

import PackageDescription

let swiftLanguageMode = SwiftLanguageMode.v5
let zTarget: Target

#if os(Windows)
let disableDeprecatedDeclarationsWarning = "-Wno-deprecated-declarations"

zTarget = Target.target(name: "Z", path: "Sources/zlib-1.3.1", cSettings: [
    .define("STDC"),
    .define("HAVE_STDARG_H"),
    .define("HAVE_HIDDEN"),

    .unsafeFlags([
        disableDeprecatedDeclarationsWarning,
    ])
])
#else
zTarget = Target.target(name: "Z", linkerSettings: [
    .linkedLibrary("z")
])
#endif

let d3desTarget = Target.target(name: "d3des")

let package = Package(
    name: "RoyalVNCKit",

    platforms: [
        .macOS(.v11),
        .iOS(.v15),
        .macCatalyst(.v15),
        .tvOS(.v15),
        .visionOS(.v1)
    ],

    products: [
        .library(
            name: "RoyalVNCKit",
            type: .dynamic,
            targets: [ "RoyalVNCKit" ]
        ),

        .executable(name: "RoyalVNCKitDemo",
                    targets: [ "RoyalVNCKitDemo" ])
    ],
    
    dependencies: [
        // Royal Apps' fork of CryptoSwift (1.9.0 plus FoundationEssentials imports),
        // pinned to a commit rather than the "foundationessentials" branch so that a
        // push to that branch cannot change what HomeVNC builds.
//        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.9.0")
        .package(url: "https://github.com/royalapplications/CryptoSwift.git", revision: "a59b4d91ebb22011656c830f874fe7152e183a57"),
        
        .package(url: "https://github.com/troughton/Cstb", from: "1.0.6")
    ],

    targets: [
        .target(
            name: "RoyalVNCKitC"
        ),

        .target(
            name: "RoyalVNCKit",

            dependencies: [
                "RoyalVNCKitC",
                .byName(name: d3desTarget.name),
                .byName(name: zTarget.name),
                .byName(name: "CryptoSwift"),
                .product(name: "stb_image", package: "Cstb", condition: .when(platforms: [ .linux, .windows, .android ]))
            ],

            swiftSettings: [
                .swiftLanguageMode(swiftLanguageMode),
                
                .unsafeFlags([
                    "-enable-library-evolution"
                ])
            ]
        ),

        d3desTarget,
        zTarget,

        .executableTarget(
            name: "RoyalVNCKitDemo",
            dependencies: [ "RoyalVNCKit" ]
        ),

        .executableTarget(
            name: "RoyalVNCKitCDemo",
            dependencies: [ "RoyalVNCKit" ]
        )
    ]
)
