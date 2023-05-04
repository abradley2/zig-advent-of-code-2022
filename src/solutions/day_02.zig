const std = @import("std");
const mecha = @import("mecha");

const day_02_error = error{
    FailedToParse
};

const RPS = enum(u2) {
    Rock,
    Paper,
    Scissors
};

fn toRPS (_ : std.mem.Allocator, c : u21) !RPS {
    return switch (c) {
        'A' => RPS.Rock,
        'B' => RPS.Paper,
        'C' => RPS.Scissors,
        'X' => RPS.Rock,
        'Y' => RPS.Paper,
        'Z' => RPS.Scissors,
        else => day_02_error.FailedToParse,
    };
}

const InputLine = struct {
    player_1 : RPS,
    player_2 : RPS,
};

const input_parser = mecha.many(
    mecha.map(
        mecha.toStruct(InputLine),
        mecha.combine(.{
            mecha.convert(toRPS, mecha.oneOf(.{mecha.utf8.range('A', 'C')})),
            mecha.discard(mecha.utf8.char(' ')),
            mecha.convert(toRPS,  mecha.oneOf(.{mecha.utf8.range('X', 'Z')})),
        }),
    ),
    .{
        .separator = mecha.discard(mecha.utf8.char('\n')),
    },
);

pub fn solve_part_1 (raw_input : []u8) !void {
    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer alloc.deinit();

    const input = try input_parser(alloc.allocator(), raw_input);
    std.debug.print("Input: {any}", .{input.value});
}