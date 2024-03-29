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

// MARK: - Option Set

/// Create an option set from a struct that contains a nested `OptionKeys` enum.
///
/// Attach this macro to a struct that contains a nested `Options` enum.
/// The struct will be transformed to conform to `OptionSet` by:
///   1. Introducing a `rawValue` stored property to track which options are set,
///    along with the necessary `RawType` typealias and initializers to satisfy
///    the `OptionSet` protocol.
///   2. Introducing static properties for each of the cases within the `OptionKeys`
///    enum, of the type of the struct.
///
/// For example, the struct and its nested `Options` enum could look like this:
///
///     @OptionSet<UInt8>
///     struct ShippingOptions {
///       private enum OptionKeys {
///         case nextDay
///         case secondDay
///         case priority
///         case standard
///       }
///     }
@attached(member, names: arbitrary)
@attached(extension, conformances: OptionSet)
public macro OptionSet<RawType>() = #externalMacro(module: "MacroExamplesImplementation", type: "OptionSetMacro")
