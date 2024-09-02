const std = @import("std");
const llm = @import("zig-llm");
const exit = std.process.exit;

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const env = try std.process.getEnvMap(alloc);

    const api_key = env.get("OPENAI_API_KEY");
    const organization_id = env.get("OPENAI_ORGANIZATION_ID");

    if (api_key == null and organization_id == null) {
        std.log.info("Please set your API key and Organization ID \n", .{});
        exit(2);
    }

    var openai = try llm.OpenAI.init(alloc, api_key.?, organization_id);
    defer openai.deinit();

    const models = try openai.get_models();
    std.debug.print("{}", .{models});

    const system_message = .{
        .role = "system",
        .content = "You are a helpful assistant",
    };

    const user_message = .{
        .role = "user",
        .content = "Write a 1 line haiku",
    };

    var messages = [2]llm.Message{ system_message, user_message };

    const payload = llm.CompletionPayload{
        .model = "gpt-3.5-turbo",
        .messages = &messages,
        .max_tokens = 64,
        .temperature = 0,
    };
    const completion = try openai.completion(payload, false);
    for (completion.choices) |choice| {
        std.debug.print("Choice:\n {s}", .{choice.message.content});
    }
}

test "simple test" {
    // an example test

    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
