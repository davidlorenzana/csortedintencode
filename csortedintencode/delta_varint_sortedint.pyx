# sorted_integers.pyx
# cython: language_level=3

import cython

@cython.cfunc
def varint_encode(number: cython.uint) -> bytes:
    """Encodes an integer using variable-length encoding (varint)."""
    cdef bytearray buf = bytearray()
    cdef cython.uint to_write
    cdef cython.uint number_c = number

    while True:
        to_write = number_c & 0x7F
        number_c >>= 7
        if number_c:
            buf.append(to_write | 0x80)
        else:
            buf.append(to_write)
            break
    return bytes(buf)

@cython.cfunc
def varint_decode(stream: bytes, start: cython.int) -> tuple[cython.uint, cython.int]:
    """
    Decodes a single varint from the stream starting at the given position.

    Args:
        stream: The byte stream containing the encoded varint.
        start: The starting index to decode from.

    Returns:
        A tuple (number, next_index) where 'number' is the decoded integer
        and 'next_index' is the index in the stream after the varint.
    """
    cdef cython.int shift = 0
    cdef cython.uint result = 0
    cdef cython.int index = start
    cdef cython.int byte_val

    while True:
        if index >= len(stream):
            raise ValueError("Incomplete varint encountered.")
        byte_val = stream[index]
        result |= (byte_val & 0x7F) << shift
        shift += 7
        index += 1
        if not (byte_val & 0x80):
            break
    return result, index

@cython.cfunc
def delta_encode(sorted_list: list[cython.int]) -> list[cython.int]:
    """
    Delta encodes a sorted list of integers.

    Returns a new list where the first element is the original first value,
    and subsequent elements are the differences between consecutive values.
    """
    cdef list deltas = []
    cdef cython.int prev_val = 0
    cdef cython.int current_val

    if not sorted_list:
        return []

    deltas.append(sorted_list[0])
    prev_val = sorted_list[0]

    for i in range(1, len(sorted_list)):
        current_val = sorted_list[i]
        deltas.append(current_val - prev_val)
        prev_val = current_val
    return deltas

cpdef bytes encode_sorted_integers(list sorted_list): # Return type is before the function name
    """
    Encodes a sorted list of integers using delta encoding and varint encoding.

    Args:
        sorted_list: A sorted list of unique positive integers.

    Returns:
        A bytes object representing the encoded list.
    """
    cdef list deltas = delta_encode(sorted_list)
    cdef bytearray encoded_bytes = bytearray()
    cdef cython.int delta
    for delta in deltas:
        encoded_bytes.extend(varint_encode(delta))
    return bytes(encoded_bytes)

cpdef list decode_sorted_integers(bytes encoded): # Return type is before the function name
    """
    Decodes a bytes object that was encoded using delta+varint encoding back into
    a sorted list of integers.

    Args:
        encoded: The byte string representing the delta+varint encoded integers.

    Returns:
        The decoded sorted list of integers.
    """
    cdef cython.int index = 0
    cdef list deltas = []
    cdef cython.uint number
    cdef cython.int next_index

    # Decode varint values until the stream is exhausted.
    while index < len(encoded):
        number, next_index = varint_decode(encoded, index)
        deltas.append(number)
        index = next_index

    cdef list result = []
    cdef cython.int delta_val
    cdef cython.int current_val = 0

    if not deltas:
        return []

    result.append(deltas[0])
    current_val = deltas[0]

    for i in range(1, len(deltas)):
        delta_val = deltas[i]
        current_val += delta_val
        result.append(current_val)
    return result
