function fail(message) {
    print "Intel HEX error: " message > "/dev/stderr"
    failed = 1
    exit 1
}

function hex_value(text,    i, digit, value) {
    value = 0
    for (i = 1; i <= length(text); i++) {
        digit = index("0123456789ABCDEF", toupper(substr(text, i, 1))) - 1
        if (digit < 0)
            fail("invalid hexadecimal value '" text "'")
        value = value * 16 + digit
    }
    return value
}

function record_byte(line, offset) {
    return hex_value(substr(line, offset, 2))
}

{
    if (eof_seen)
        fail("data found after EOF record")
    if ($0 !~ /^:[[:xdigit:]]+$/)
        fail("line " NR " is not a valid Intel HEX record")

    count = record_byte($0, 2)
    if (length($0) != 11 + count * 2)
        fail("incorrect record length on line " NR)

    checksum_sum = 0
    for (offset = 2; offset < length($0); offset += 2)
        checksum_sum += record_byte($0, offset)
    if (checksum_sum % 256 != 0)
        fail("checksum mismatch on line " NR)

    address = record_byte($0, 4) * 256 + record_byte($0, 6)
    record_type = record_byte($0, 8)

    if (record_type == 0) {
        if (address + count > 65536)
            fail("data record crosses a 64 KiB boundary on line " NR)
        for (i = 0; i < count; i++) {
            absolute_address = base_address + address + i
            if (absolute_address in present)
                fail("overlapping data at address 0x" sprintf("%x", absolute_address))
            present[absolute_address] = 1
            data[absolute_address] = record_byte($0, 10 + i * 2)
            if (!have_data || absolute_address < lowest_address)
                lowest_address = absolute_address
            if (!have_data || absolute_address > highest_address)
                highest_address = absolute_address
            have_data = 1
        }
    } else if (record_type == 1) {
        if (count != 0 || address != 0)
            fail("malformed EOF record on line " NR)
        eof_seen = 1
    } else if (record_type == 2) {
        if (count != 2 || address != 0)
            fail("malformed extended segment address on line " NR)
        base_address = (record_byte($0, 10) * 256 + record_byte($0, 12)) * 16
    } else if (record_type == 4) {
        if (count != 2 || address != 0)
            fail("malformed extended linear address on line " NR)
        base_address = (record_byte($0, 10) * 256 + record_byte($0, 12)) * 65536
    } else if (record_type == 3 || record_type == 5) {
        if (count != 4 || address != 0)
            fail("malformed start address record on line " NR)
    } else {
        fail("unsupported record type " record_type " on line " NR)
    }
}

END {
    if (failed)
        exit 1
    if (!eof_seen)
        fail("missing EOF record")
    if (!have_data)
        fail("no data records found")
    if (lowest_address != 0)
        fail("text data starts at 0x" sprintf("%x", lowest_address) ", expected address 0")
    if ((highest_address + 1) % 2 != 0)
        fail("text data has an odd number of bytes")

    for (address = lowest_address; address <= highest_address; address++) {
        if (!(address in present))
            fail("missing data at address 0x" sprintf("%x", address))
    }

    for (row_address = lowest_address; row_address <= highest_address; row_address += 16) {
        printf "%04x:     ", row_address
        row_end = row_address + 15
        if (row_end > highest_address)
            row_end = highest_address
        for (address = row_address; address <= row_end; address += 2) {
            if (address > row_address)
                printf "  "
            printf "%02x%02x", data[address], data[address + 1]
        }
        printf "\n"
    }
}
