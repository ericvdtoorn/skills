# Main-agent implementation (SMALL branch)

The change is localised and single-purpose. No orchestration overhead — just build it here, well, and commit it.

## 1. Implement directly

Make the change yourself in this session. Reuse the functions and patterns already in the codebase rather than inventing parallel ones, and match the style of the surrounding code.

## 2. Use TDD where tests make sense

If the change has behaviour worth pinning down, follow [tdd](../tdd/SKILL.md) — red-green-refactor, one test at a time. If it's the kind of change tests don't fit (config, copy, a trivial wiring tweak), skip the ceremony and verify by running it instead.

## 3. Honour comment-style

No explanatory inline comments — if you feel the urge to explain *what* the next lines do, extract a named function instead. See [comment-style](../comment-style/SKILL.md).

## 4. Commit once, at the end

When the change is done and its checks are green, **commit it** with a single gitmoji line per [gitmoji-commits](../gitmoji-commits/SKILL.md) — one functional purpose. **Auto-commit — don't wait to be asked.**

If, partway through, the change turns out to be bigger than it looked — it's sprawling across modules or wanting several commits — stop and switch to [SUBAGENT.md](SUBAGENT.md).
