//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import MacroExamples

// MARK: - Option Set

@OptionSet<UInt8>
struct ShippingOptions {
  private enum OptionKeys {
    case nextDay
    case secondDay
    case priority
    case standard
  }

  static let express: ShippingOptions = [.nextDay, .secondDay]
  static let all: ShippingOptions = [.express, .priority, .standard]
}

func runOptionSetMacroPlayground() {
    [
        ("nextDay", ShippingOptions.nextDay),
        ("secondDay", ShippingOptions.secondDay),
        ("priority", ShippingOptions.priority),
        ("standard", ShippingOptions.standard),
        ("express", ShippingOptions.express),
        ("all", ShippingOptions.all),
    ].forEach {
        print("option set raw value: '\($0)'", $1.rawValue, String($1.rawValue, radix: 2))
    }
}
