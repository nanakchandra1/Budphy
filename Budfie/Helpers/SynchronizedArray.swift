//
//  SynchronizedArray.swift
//
//  Created by Robert Ryan on 12/24/17.
//

import Foundation

/// A synchronized, ordered, random-access array.
///
/// This provides low-level synchronization for an array, employing the
/// reader-writer pattern (using concurrent queue, allowing concurrent
/// "reads" but using barrier to ensure nothing happens concurrently with
/// respect to "writes".
///
/// - Note: This may not be sufficient to achieve thread-safety,
///         as that is often only achieved with higher-level synchronization.
///         But for many situations, this can be sufficient.

class SynchronizedArray<Element> {
    private var array: Array<Element>

    private let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".synchronization", attributes: .concurrent)

    init(array: Array<Element> = []) {
        self.array = array
    }

    /// First element in the collection.

    var first: Element? {
        return queue.sync { self.array.first }
    }

    /// Last element in the collection.

    var last: Element? {
        return queue.sync { self.array.last }
    }

    /// The number of elements in the collection.

    var count: Int {
        return queue.sync { self.array.count }
    }

    /// Inserts new element at the specified position.
    ///
    /// - Parameters:
    ///   - newElement: The element to be inserted.
    ///   - index: The position at which the element should be inserted.

    func insert(_ newElement: Element, at index: Int) {
        queue.async(flags: .barrier) {
            self.array.insert(newElement, at: index)
        }
    }

    /// Appends new element at the end of the collection.
    ///
    /// - Parameter newElement: The element to be appended.

    func append(_ newElement: Element) {
        queue.async(flags: .barrier) {
            self.array.append(newElement)
        }
    }

    /// Removes all elements from the array.

    func removeAll() {
        queue.async {
            self.array.removeAll()
        }
    }

    /// Remove specific element from the array.
    ///
    /// - Parameter index: The position of the element to be removed.

    func remove(at index: Int) {
        queue.async {
            self.array.remove(at: index)
        }
    }

    /// Retrieve or update the element at a particular position in the array.
    ///
    /// - Parameter index: The position of the element.

    subscript(index: Int) -> Element {
        get {
            return queue.sync { self.array[index] }
        }
        set {
            queue.async(flags: .barrier) { self.array[index] = newValue }
        }
    }

    /// Perform a writer block of code asynchronously within the synchronization system for this array.
    ///
    /// This is used for performing updates, where no result is returned. This is the "writer" in
    /// the "reader-writer" pattern, which performs the block asynchronously with a barrier.
    ///
    /// For example, the following checks to see if the array has one or more values, and if so,
    /// remove the first item:
    ///
    ///     synchronizedArray.writer { array in
    ///         if array.count > 0 {
    ///             array.remove(at: 0)
    ///         }
    ///     }
    ///
    /// In this example, we use the `writer` method to avoid race conditions between checking
    /// the number of items in the array and the removing of the first item.
    ///
    /// If you are not performing updates to the array itself or its values, it is more efficient
    /// to use the `reader` method.
    ///
    /// - Parameter block: The block to be performed. This is allowed to mutate the array. This is
    ///                    run on a private synchronization queue using a background thread.

    func writer(with block: @escaping (inout [Element]) -> Void) {
        queue.async(flags: .barrier) {
            block(&self.array)
        }
    }

    /// Perform a "reader" block of code within the synchronization system for this array.
    ///
    /// This is the "reader" in the "reader-writer" pattern. This performs the read synchronously,
    /// potentially concurrently with other "readers", but never concurrently with any "writers".
    ///
    /// This is used for reading and performing calculations on the array, where a whole block of
    /// code needs to be synchronized. The block may, optionally, return a value.
    /// This should not be used for performing updates on the array itself. To do updates,
    /// use `writer` method.
    ///
    /// For example, if dealing with array of integers, you could average them with:
    ///
    ///     let average = synchronizedArray.reader { array -> Double in
    ///         let count = array.count
    ///         let sum = array.reduce(0, +)
    ///         return Double(sum) / Double(count)
    ///     }
    ///
    /// This example ensures that there is no race condition between the checking of the
    /// number of items in the array and the calculation of the sum of the values.
    ///
    /// - Parameter block: The block to be performed. This is not allowed to mutate the array.
    ///                    This runs on a private synchronization queue (so if you need main queue,
    ///                    you will have to dispatch that yourself).

    func reader<U>(block: ([Element]) -> U) -> U {
        return queue.sync {
            block(self.array)
        }
    }

    /// Retrieve the array for use elsewhere.
    ///
    /// This resulting array is a copy of the underlying `Array` used by `SynchronizedArray`.
    /// This copy will not participate in any further synchronization.

    var value: Array<Element> { return queue.sync { self.array } }
}

extension SynchronizedArray: CustomStringConvertible {
    // Use the description of the underlying array

    var description: String { return queue.sync { self.array.description } }
}
