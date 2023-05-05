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

fn to_score (rps : RPS) u64 {
    return switch (rps) {
        RPS.Rock => 1,
        RPS.Paper => 2,
        RPS.Scissors => 3,
    };
}

fn play_round (player_1 : RPS, player_2 : RPS ) u64 {
    const outcome_score : u64 = switch (player_1) {
        RPS.Rock => switch (player_2) {
            RPS.Paper => 0,
            RPS.Rock => 3,
            RPS.Scissors => 6,
        },
        RPS.Paper => switch (player_2) {
            RPS.Scissors => 0,
            RPS.Paper => 3,
            RPS.Rock => 6,
        },
        RPS.Scissors => switch (player_2) {
            RPS.Rock => 0,
            RPS.Scissors => 3,
            RPS.Paper => 6,
        },
    };
    return to_score(player_1) + outcome_score;
}


const InputLine = struct {
    player_2 : RPS,
    player_1 : RPS,
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

    var total_score : u64 = 0;
    for (input.value) |line| {
        total_score += play_round(line.player_1, line.player_2);
    }
    std.debug.print("Part 1: {d}\n", .{total_score});
}

pub fn solve_part_2 (raw_input : []u8) !void {
    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer alloc.deinit();

    const input = try input_parser(alloc.allocator(), raw_input);

    var total_score : u64 = 0;
    for (input.value) |line| {
        const player_1 = switch (line.player_1) {
            // lose 
            RPS.Rock => switch (line.player_2) {
                RPS.Rock => RPS.Scissors,
                RPS.Paper => RPS.Rock,
                RPS.Scissors => RPS.Paper,
            },
            // draw 
            RPS.Paper => switch (line.player_2) {
                RPS.Rock => RPS.Rock,
                RPS.Paper => RPS.Paper,
                RPS.Scissors => RPS.Scissors,
            },
            // win
            RPS.Scissors => switch (line.player_2) {
                RPS.Rock => RPS.Paper,
                RPS.Paper => RPS.Scissors,
                RPS.Scissors => RPS.Rock,
            }
        };
        total_score += play_round(player_1, line.player_2);
    }
    std.debug.print("Part 2: {d}\n", .{total_score});
}