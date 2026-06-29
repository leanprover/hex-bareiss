#!/usr/bin/env bash
# FLINT conformance cross-check for the released `hex-bareiss` repo.
set -uo pipefail
lib="HexBareiss"
fixture="conformance-fixtures/HexBareiss/bareiss.jsonl"
fresh="/tmp/HexBareiss-fresh.jsonl"
echo ">>> $lib :: emit=hexbareiss_emit_fixtures oracle=scripts/oracle/matrix_flint.py"
if ! (cd conformance && lake exe hexbareiss_emit_fixtures) >"$fresh"; then
  echo "FAIL: $lib :: emit exited non-zero" >&2; exit 1; fi
if ! diff -u "$fixture" "$fresh"; then
  echo "FAIL: $lib :: fresh emission diverges from committed fixture" >&2; exit 1; fi
if ! python3 scripts/oracle/matrix_flint.py <"$fresh"; then
  echo "FAIL: $lib :: oracle reported a divergence" >&2; exit 1; fi
echo "Conformance: $lib oracle passed."
