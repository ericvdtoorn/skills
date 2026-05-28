---
name: comment-style
description: Reference for the evantoor comment convention — doc comments encouraged on public surfaces, inline comments heavily discouraged. When you feel the urge to write an explaining inline comment, extract a named function instead. Use when writing or reviewing comments, refactoring code that's accumulated explanatory cruft, or deciding whether to keep an existing comment.
---

# Comment Style

Two rules:

1. **Doc comments are encouraged** on public APIs — functions, types, modules, exported constants. They tell a caller *how to use this* without reading the body.
2. **Inline comments are heavily discouraged.** If you feel the urge to write one explaining *what the next few lines do*, that's a signal to **extract a named function** whose name carries the explanation.

The rare exceptions are listed at the bottom — they cover non-obvious *why*, not *what*.

## The refactor pattern

Whenever you reach for an inline comment to explain what comes next, stop and extract instead.

### Before — inline comment explaining what

```ts
function processOrder(order: Order) {
  // validate the order has at least one line item and a billing address
  if (order.items.length === 0 || !order.billingAddress) {
    throw new ValidationError("invalid order");
  }

  // compute the total including tax for the customer's region
  let total = 0;
  for (const item of order.items) {
    total += item.price * item.quantity;
  }
  total += total * taxRateFor(order.billingAddress.region);

  // ...
}
```

### After — names carry the meaning

```ts
function processOrder(order: Order) {
  assertOrderIsValid(order);
  const total = totalIncludingTax(order);
  // ...
}

function assertOrderIsValid(order: Order): void {
  if (order.items.length === 0 || !order.billingAddress) {
    throw new ValidationError("invalid order");
  }
}

function totalIncludingTax(order: Order): number {
  const subtotal = order.items.reduce((sum, i) => sum + i.price * i.quantity, 0);
  return subtotal + subtotal * taxRateFor(order.billingAddress.region);
}
```

Each comment became a function name. The caller's body now reads like prose without commentary.

### Why this is better

- The "comment" can't drift out of sync with the code — the function *is* its name.
- The extracted function is testable in isolation.
- A future reader gets the gist from `processOrder` alone without parsing the body.
- If the logic gets reused, you already have the seam.

## What counts as a doc comment vs. an inline comment

| Kind | Where | Convention | Status |
| --- | --- | --- | --- |
| Doc comment | Directly above a public function/type/module | `/** … */` (JS/TS), `"""…"""` (Python), `///` (Rust), `// …` (Go) | **Encouraged** |
| Inline comment | Inside a function body, above a few lines | `// …` / `# …` | **Discouraged — extract instead** |
| Trailing comment | End of a line, beside code | `// …` after the statement | **Discouraged — extract or rename** |
| TODO/FIXME marker | Anywhere | `// TODO(eric): …` | Allowed; not really "a comment" — it's a marker |
| License/SPDX header | Top of file | tool-specific | Allowed |

Doc comments are *for the caller*. Inline comments are *for the next reader of the body* — but the body should explain itself.

## What a good doc comment looks like

- One-line summary of what the function/type *does* (not how it works).
- Constraints on inputs and outputs that aren't already in the type.
- Side effects (writes to disk, mutates a shared variable, makes a network call).
- Examples if the API is non-obvious.

Skip:
- Restating the signature in prose ("Takes a string and returns a number" — the type already says that).
- Implementation details ("Uses a hashmap internally" — that's not the caller's business).
- Change log entries ("Added in v1.2" — that's what git tells you).

### Example

```ts
/**
 * Resolve a triage role to the literal label string used in this repo's tracker.
 * Returns null when no mapping exists — caller should treat that as a config gap, not an error.
 */
export function resolveTriageLabel(role: TriageRole): string | null { … }
```

## The exceptions — when an inline comment is the right tool

Keep these *rare*. Each one should explain a **WHY** that no name can carry.

- **Workaround for a specific bug or upstream issue.** Link to the bug.
  ```ts
  // workaround: stripe sometimes returns null here under load (see stripe/stripe-node#1543)
  if (charge?.outcome == null) return retry();
  ```
- **Subtle invariant the type system doesn't enforce.**
  ```ts
  // invariant: indices are sorted ascending; binary search depends on this
  ```
- **Surprising behaviour a reader would otherwise misread.**
  ```ts
  // intentional: we want this to throw — the caller's catch turns it into a 4xx
  ```
- **Required by a lint or compiler.** e.g. `SAFETY:` blocks above `unsafe` Rust.

If you're tempted to write a comment and it doesn't fit one of these, extract a function instead.

## When reviewing existing code

- Comments that restate what the code does → delete + maybe extract.
- Comments that drift from the code → fix the code (or the comment, if the comment is right).
- Doc comments on private/internal functions → fine to keep, fine to delete; not load-bearing.
- WHY comments that link to issues/RFCs → keep, they're load-bearing.

Don't bulk-delete on sight — read each one and decide. The bar is "would removing this confuse a future reader?"
