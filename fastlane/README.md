fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test

```sh
[bundle exec] fastlane ios test
```

Run XCTest on iPhone Simulator (prefers iPhone 17; falls back to any available iPhone)

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Archive and upload to TestFlight (API key + APPLE_TEAM_ID required)

### ios release

```sh
[bundle exec] fastlane ios release
```

Archive, upload listing if present, submit for review only when required assets exist

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
