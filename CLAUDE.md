# Global Code Standards

## 1. Fail-Fast, Never Silent

- Prefer code that crashes on wrong assumptions over code that silently continues with wrong values. Use `assert` for preconditions at function boundaries.
- Never use silent fallbacks (`if x is None: x = default`) to mask caller bugs. If a value is required, its absence should crash.
- Never swallow exceptions broadly. `except Exception` and bare `except:` are forbidden. Narrow to exact exception types (e.g., `except OSError`) and always have a specific reason.
- Never use `.get(key, fallback)` when the key must exist. Use `dict[key]` and let it crash with a clear `KeyError`.
- Never use `try/except` for flow control. If you need to check a condition, check it explicitly before the operation.

## 2. Tensor Discipline

- Assert shapes, dtypes, and ndim at function entry points. A caught assertion is debuggable in seconds; a wrong output wastes days.
- Never assume broadcasting will do the right thing — if two tensors should have matching dimensions, assert it explicitly.
- Cast dtypes explicitly (`x.to(dtype=...)`, `.astype(...)`) — never rely on implicit promotion.
- When slicing with hardcoded indices (e.g., `state[:, :14]`), add a comment or FIXME noting what the magic number means and where it comes from.

## 3. Data Loading and I/O

- Validate schema immediately after loading from disk (JSON, NPZ, checkpoint): check expected keys, types, shapes.
- Check file existence before loading and raise a descriptive error with the path — don't let raw `FileNotFoundError` propagate without context.
- Never overwrite existing result files without explicit user confirmation.

## 4. Communication

- Verify or ask before making claims. If uncertain about something, say so — never present speculation as fact.
- Never make judgment calls on ambiguous decisions (design choices, defaults, error behavior, what to keep/remove). Ask the user.
- When something could go wrong silently, flag it proactively — even if it's not a bug yet.
