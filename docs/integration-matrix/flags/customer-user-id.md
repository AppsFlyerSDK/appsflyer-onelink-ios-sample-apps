# Customer User ID (CUID)

**Purpose:** Tag every event sent by the SDK with your app's internal user identifier. The CUID flows through to raw-data reports and downstream BI so attribution can be reconciled against your own user model.

## Where it lives

| Sample | File | Line |
|--------|------|------|
| obj-c | `obj-c/obj-c/AppDelegate.m` | 32-33 |
| swift | `swift/basic_app/basic_app/AppDelegate.swift` | 27-28 |
| swiftui | `swiftui/basic_app_swiftui/AppDelegate.swift` | 39-40 |

Set **after** `initialize(...)` and **before** `start()`. Setting it before `start()` ensures the install event itself carries the CUID; setting it after `start()` only tags subsequent events.

## Swift

```swift
// MARK: - [Matrix flag] Customer User ID (CUID)
AppsFlyerLib.shared().customerUserID = "my user id"
```

## Objective-C

```objectivec
#pragma mark - [Matrix flag] Customer User ID (CUID)
[AppsFlyerLib shared].customerUserID = @"my user id";
```

## Behavioral notes

- **Persistence:** the SDK stores the CUID across launches. Set it once; it sticks until you change it or call `setCustomerUserID(nil)`.
- **Timing:** set before `start()` to include it on the install event. If your user identifier is only known after login, set it then — the install will be re-attributed once it arrives, but only via downstream reconciliation, not on the original install row.
- **Threading:** simple property setter, safe from any thread. Conventionally main.
- **Privacy:** the CUID is yours — don't use raw PII (email, phone) as the value. Hash if needed. Most apps use a backend-issued opaque ID.
- **If omitted:** events ship without `customer_user_id`. Attribution still works; you just can't join reports back to your own user table by this column.
- **Anonymize interaction:** if `anonymizeUser = true`, the CUID is still sent. `anonymizeUser` suppresses device identifiers, not your CUID.
