const std = @import("std");
const mecha = @import("mecha");
const solutions_day_01 = @import("solutions/day_01.zig");

const Day = enum(u8) {
    day_01,
    day_02,
    day_03,
    day_04,
    day_05,
    day_06,
    day_07,
    day_08,
    day_09,
    day_10,
    day_11,
    day_12,
    day_13,
    day_14,
    day_15,
    day_16,
    day_17,
    day_18,
    day_19,
    day_20,
    day_21,
    day_22,
    day_23,
    day_24,
    day_25,
};

const Args = struct {
    day: ?Day = null,
};

const day_parse = mecha.combine(.{
    mecha.discard(mecha.string("--day=")),
    mecha.int(u8, .{
        .parse_sign = false,
        .base = 10,
        .max_digits = 2,
    })
});

pub fn main () !void {
    var input_buff : [1_024 * 15]u8 = undefined;
    var input_alloc = std.heap.FixedBufferAllocator.init(&input_buff);

    const args = try std.process.argsAlloc(input_alloc.allocator());

    var parsed_args = Args {};

    var i : u32 = 0;
    while (i < args.len) {
        if (parsed_args.day == null) {
            if (day_parse(input_alloc.allocator(), args[i]) catch null) |result| {
                parsed_args.day = @intToEnum(Day, result.value - 1);
            }
        } 
        i += 1;
    }

    input_alloc.reset();

    if (parsed_args.day) |day| {
        std.debug.print("Running day {}\n", .{day});
        switch (day) {
            Day.day_01 => try solutions_day_01.solve(input_alloc.allocator()),
            else => std.debug.print("No solution for day\n", .{}),
        }
    } else {
        std.debug.print("No argument for --day found", .{});
    }
}
