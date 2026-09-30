public import Byte
import Byte
public import Coder
public import Cursor
public import Cursor
public import RFC_9110
public import RFC_9111
import Parser
import Serializer

extension RFC_9110.Cache.Age {

    public struct Coder<
        Input: Cursor.`Protocol`<Byte, Never>,
        Buffer: RangeReplaceableCollection<Byte>
    >: Coding {

        public typealias Output = RFC_9110.Cache.Age

        public typealias Failure = RFC_9110.Cache.Age.Error

        public init() {}

        public borrowing func parse(_ input: inout Input) throws(Failure) -> RFC_9110.Cache.Age {
            let digits = Scanning.take(&input) { (0x30...0x39).contains($0.bitPattern) }

            guard !digits.isEmpty else {
                throw .empty
            }

            let text = Scanning.text(digits)

            guard let seconds = Int(text) else {
                throw .overflow(text)
            }

            return RFC_9110.Cache.Age(seconds: seconds)
        }

        public borrowing func serialize(
            _ output: RFC_9110.Cache.Age,
            into buffer: inout Buffer
        ) throws(Failure) {
            buffer.append(contentsOf: Scanning.bytes(String(output.seconds)))
        }
    }

    public static var coder: Coder<ArraySlice<Byte>, [Byte]> { .init() }

    public enum Error: Swift.Error, Equatable {

        case empty

        case overflow(String)
    }
}

