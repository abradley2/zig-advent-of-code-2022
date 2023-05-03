const std = @import("std");
const mecha = @import("mecha");

const input_parser = mecha.many(
    mecha.many(
        mecha.int(u64, .{}),
        .{
            .separator = mecha.string("\n"),
        }
    ),
    .{
        .separator = mecha.string("\n\n"),
    }
);

pub fn solve_part_2 (input_slice : []const u8) !void {
    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const parsed = try input_parser(alloc.allocator(), input_slice);

    var max_1 : u64 = 0;
    var max_2 : u64 = 0;
    var max_3 : u64 = 0;

    for (parsed.value) |elf| {
        var calories : u64 = 0;
        for (elf) |snack| {
            calories += snack;
        }
        if (calories > max_1) {
            max_3 = max_2;
            max_2 = max_1;
            max_1 = calories;
        } else if (calories > max_2) {
            max_3 = max_2;
            max_2 = calories;
        } else if (calories > max_3) {
            max_3 = calories;
        }
    }

    std.debug.print("part_2 = {d}\n", .{max_1 + max_2 + max_3});
}

pub fn solve_part_1 (input_slice : []const u8) !void {
    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const parsed = try input_parser(alloc.allocator(), input_slice);

    var max : u64 = 0;

    for (parsed.value) |elf| {
        var calories : u64 = 0;
        for (elf) |snack| {
            calories += snack;
        }
        max = @max(max, calories);
    }

    std.debug.print("part_1 = {d}\n", .{max});
}