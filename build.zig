const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dep_opts = .{ .target = target, .optimize = optimize };
    _ = dep_opts;

    _ = b.addModule("zig-llm", .{
        .root_source_file = b.path("src/main.zig"),
        // .dependencies = &.{},
    });
}
