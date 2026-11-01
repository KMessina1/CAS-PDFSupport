# CAS-PDFSupport

Reusable PDF viewing, thumbnail, import, export, and report-generation support for Creative App Solutions applications.

## What's New

### 1.1.4

Image loading changes.

## Requirements

- Xcode 26 or newer
- iOS 26 or newer
- Mac Catalyst 26 or newer

## Installation

Add the package dependency using:

`https://github.com/KMessina1/CAS-PDFSupport.git`

Then import the library where required:

```swift
import CASPDFSupport
```

## App-owned share access

`needsPurchasable: Bool = false` is a caller-provided restriction, not an entitlement check. Existing callers remain unrestricted by default.
When true, Share shows "Subscription Required" / "This choice requires a subscription." and does not open the activity sheet, including its Print action. Supply `subscriptionDestination: AnyView(...)` to provide the host app's Subscriptions destination. The package does not import or read purchase state.
