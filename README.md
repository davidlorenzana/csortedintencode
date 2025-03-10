# csortedintencode

**Efficiently Encode and Decode Sorted Integer Lists in Python (Cython Optimized)**

`csortedintencode` is a Python library designed for highly efficient encoding and decoding of sorted lists of integers. Implemented in Cython, it achieves significant performance improvements over pure Python implementations while also providing substantial space savings.

This library utilizes a combination of two powerful techniques:

  * **Delta Encoding:**  Reduces the magnitude of numbers in sorted lists by storing the difference between consecutive values. This is especially effective when dealing with sequences where numbers are close to each other (e.g., timestamps, IDs, time-series data).
  * **Varint Encoding (Variable-Length Encoding):**  Represents integers using a variable number of bytes. Smaller integers are encoded with fewer bytes, minimizing the storage space required for frequently occurring small values.

By combining delta and varint encoding, `csortedintencode` offers a compact and fast way to serialize sorted integer data for storage, transmission, or other applications where efficiency matters.

## Key Features

  * **Highly Efficient:** Implemented in Cython for near-C performance, significantly faster than pure Python alternatives.
  * **Space-Saving:**  Combines delta and varint encoding to minimize the byte representation of sorted integer lists.
  * **Arbitrary Length Integer Lists:** Handles lists of integers of any size, limited only by system memory.
  * **Handles Integers \> 256:** Supports integers beyond the single-byte range, encoding them appropriately using varint.
  * **Simple API:** Easy-to-use functions for both encoding and decoding.
  * **MIT Licensed:** Openly licensed for free use in your projects.

## Installation

You can install `csortedintencode` using pip:

```bash
pip install csortedintencode
```

## Usage

Here's a quick example of how to use the library to encode and decode a sorted list of integers:

```python
from csortedintencode import encode_sorted_integers, decode_sorted_integers

# Example sorted list of integers
sorted_numbers = [100, 101, 103, 105, 110, 250, 255, 1000, 1500]

# Encode the list to bytes
encoded_bytes = encode_sorted_integers(sorted_numbers)
print(f"Encoded bytes: {encoded_bytes}")
print(f"Encoded bytes (hex): {encoded_bytes.hex()}")

# Decode the bytes back to a list of integers
decoded_numbers = decode_sorted_integers(encoded_bytes)
print(f"Decoded integers: {decoded_numbers}")

# Verify that the decoded list is the same as the original
assert decoded_numbers == sorted_numbers
print("Decoding successful!")
```

## Performance

`csortedintencode` is designed for speed. By leveraging Cython and optimized algorithms, it offers substantial performance gains compared to pure Python implementations for encoding and decoding sorted integer lists.  The combination of delta and varint encoding also results in significant space savings, particularly for lists where consecutive numbers are close in value.

## License

`csortedintencode` is released under the MIT License. See the [LICENSE](LICENSE) file for details.
