const std = @import("std");
const mecha = @import("mecha");
const solutions_day_01 = @import("solutions/day_01.zig");
const solutions_day_02 = @import("solutions/day_02.zig");

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

fn get_input (alloc: std.mem.Allocator, day: Day) ![]u8 {
    const file_name = switch (day) {
        Day.day_01 => "input/day_01.txt",
        Day.day_02 => "input/day_02.txt",
        Day.day_03 => "input/day_03.txt",
        Day.day_04 => "input/day_04.txt",
        Day.day_05 => "input/day_05.txt",
        Day.day_06 => "input/day_06.txt",
        Day.day_07 => "input/day_07.txt",
        Day.day_08 => "input/day_08.txt",
        Day.day_09 => "input/day_09.txt",
        Day.day_10 => "input/day_10.txt",
        Day.day_11 => "input/day_11.txt",
        Day.day_12 => "input/day_12.txt",
        Day.day_13 => "input/day_13.txt",
        Day.day_14 => "input/day_14.txt",
        Day.day_15 => "input/day_15.txt",
        Day.day_16 => "input/day_16.txt",
        Day.day_17 => "input/day_17.txt",
        Day.day_18 => "input/day_18.txt",
        Day.day_19 => "input/day_19.txt",
        Day.day_20 => "input/day_20.txt",
        Day.day_21 => "input/day_21.txt",
        Day.day_22 => "input/day_22.txt",
        Day.day_23 => "input/day_23.txt",
        Day.day_24 => "input/day_24.txt",
        Day.day_25 => "input/day_25.txt",
    };

    const input_file : std.fs.File = try std.fs.cwd().openFile(file_name, .{});
    defer input_file.close();

    return input_file.readToEndAlloc(alloc, 1_024 * 15);
}

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
        const input = try get_input(input_alloc.allocator(), day);
        std.debug.print("Running day {}\n", .{day});
        switch (day) {
            Day.day_01 => {
                try solutions_day_01.solve_part_1(input);
                try solutions_day_01.solve_part_2(input);
            },
            Day.day_02 => {
                try solutions_day_02.solve_part_1(input);
            },
            else => std.debug.print("No solution for day\n", .{}),
        }
    } else {
        std.debug.print("No argument for --day found", .{});
    }
}

