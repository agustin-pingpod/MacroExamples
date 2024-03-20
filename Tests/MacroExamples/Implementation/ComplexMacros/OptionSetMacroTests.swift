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

@testable import MacroExamplesImplementation
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class OptionSetMacroTests: XCTestCase {
  private let macros = ["OptionSet": OptionSetMacro.self]

  func testExpansionOnStructWithNestedEnumAndStatics() {
    assertMacroExpansion(
      """
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
      """,
      expandedSource: """
        struct ShippingOptions {
          private enum OptionKeys {
            case nextDay
            case secondDay
            case priority
            case standard
          }

          static let express: ShippingOptions = [.nextDay, .secondDay]
          static let all: ShippingOptions = [.express, .priority, .standard]

          typealias RawValue = UInt8

          var rawValue: RawValue

          init() {
            self.rawValue = 0
          }

          init(rawValue: RawValue) {
            self.rawValue = rawValue
          }

          static let nextDay: Self = Self(rawValue: 1 << 0)

          static let secondDay: Self = Self(rawValue: 1 << 1)

          static let priority: Self = Self(rawValue: 1 << 2)

          static let standard: Self = Self(rawValue: 1 << 3)
        }

        extension ShippingOptions: OptionSet {
        }
        """,
      macros: macros,
      indentationWidth: .spaces(2)
    )
  }

  func testExpansionOnPublicStructWithExplicitOptionSetConformance() {
    assertMacroExpansion(
      """
      @OptionSet<UInt8>
      public struct ShippingOptions: OptionSet {
        private enum OptionKeys {
          case nextDay
          case standard
        }
      }
      """,
      expandedSource: """
        public struct ShippingOptions: OptionSet {
          private enum OptionKeys {
            case nextDay
            case standard
          }

          public typealias RawValue = UInt8

          public var rawValue: RawValue

          public init() {
            self.rawValue = 0
          }

          public init(rawValue: RawValue) {
            self.rawValue = rawValue
          }

          public  static let nextDay: Self = Self(rawValue: 1 << 0)

          public  static let standard: Self = Self(rawValue: 1 << 1)
        }
        """,
      macros: macros,
      indentationWidth: .spaces(2)
    )
  }

  func testExpansionFailsOnEnumType() {
    assertMacroExpansion(
      """
      @OptionSet<UInt8>
      enum Animal {
        case dog
      }
      """,
      expandedSource: """
        enum Animal {
          case dog
        }
        """,
      diagnostics: [
        DiagnosticSpec(
          message: "'OptionSet' macro can only be applied to a struct",
          line: 1,
          column: 1
        )
      ],
      macros: macros,
      indentationWidth: .spaces(2)
    )
  }

  func testExpansionFailsWithoutNestedOptionsEnum() {
    assertMacroExpansion(
      """
      @OptionSet<UInt8>
      struct ShippingOptions {
        static let express: ShippingOptions = [.nextDay, .secondDay]
        static let all: ShippingOptions = [.express, .priority, .standard]
      }
      """,
      expandedSource: """
        struct ShippingOptions {
          static let express: ShippingOptions = [.nextDay, .secondDay]
          static let all: ShippingOptions = [.express, .priority, .standard]
        }
        """,
      diagnostics: [
        DiagnosticSpec(
          message: "'OptionSet' macro requires nested options enum 'OptionKeys'",
          line: 1,
          column: 1
        )
      ],
      macros: macros,
      indentationWidth: .spaces(2)
    )
  }

  func testExpansionFailsWithoutSpecifiedRawType() {
    assertMacroExpansion(
      """
      @OptionSet
      struct ShippingOptions {
        private enum OptionKeys {
          case nextDay
        }
      }
      """,
      expandedSource: """
        struct ShippingOptions {
          private enum OptionKeys {
            case nextDay
          }
        }
        """,
      diagnostics: [
        DiagnosticSpec(
          message: "'OptionSet' macro requires a raw type",
          line: 1,
          column: 1
        )
      ],
      macros: macros,
      indentationWidth: .spaces(2)
    )
  }
}
