const builtin = @import("builtin");

test "casting random address to function pointer" {
    if (builtin.zig_backend == .stage2_llvm and builtin.cpu.arch == .aarch64) return error.SkipZigTest; // TODO
    randomAddressToFunction();
    comptime randomAddressToFunction();
}

fn randomAddressToFunction() void {
    var addr: usize = 0xdeadbeef;
    _ = @intToPtr(fn () void, addr);
}

test "mutate through ptr initialized with constant intToPtr value" {
    forceCompilerAnalyzeBranchHardCodedPtrDereference(false);
}

fn forceCompilerAnalyzeBranchHardCodedPtrDereference(x: bool) void {
    const hardCodedP = @intToPtr(*volatile u8, 0xdeadbeef);
    if (x) {
        hardCodedP.* = hardCodedP.* | 10;
    } else {
        return;
    }
}
