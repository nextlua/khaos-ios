# Installation

## Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding Khaos as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
    dependencies: [
        .package(url: "https://github.com/nextlua/khaos-ios.git")
    ]
```

# How To Use

```swift
import Khaos

NXKhaos.start(apikey: "your api key")
```

## Disable Shaking

```swift
NXKhaos.start(apikey: "your api key", isShakeActive: false)
```

## Disable ScreenShot

```swift
NXKhaos.start(apikey: "your api key", isScreenShotActive: false)
```

## Show Khaos Manually

```swift
NXKhaos.showKhaos()
```

## Notice

> In order to use Network Interceptor your base request must be handled with `Alamofire` .