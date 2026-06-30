---
AGENT_TITLE: TDD Requirements
AGENT_DESCRIPTION: Test-driven development rules for the kit — write a failing test before any production code.
AGENT_USAGE: Load when implementing features or fixes; defines the mandatory TDD workflow.
---

# TDD is required
- We want to test first. When it comes to a new addition, we should flesh out the test concepts
- We are focusing on integration tests
- IMPORTANT! TDD is not optional. It is the mechanism by which we validate assumptions.
- IMPORTANT! When a user reports a problem or requests a feature, the FIRST step is to write a failing test that proves the problem exists or defines the expected behavior.
- IMPORTANT! Do NOT write production code until you have a failing test. Acknowledging TDD rules and then skipping to implementation is a violation.
- The sequence is ALWAYS: **Rules → Failing Test → Implementation → Pass → Triangulate**
- TDD proves the validity of statements. Without a test, you are speculating. Speculation is not engineering.

# CRITICAL: GAB SCRIPTS REQUIRE GAB TDD -- DLL TESTS ALONE ARE NOT SUFFICIENT
- **If the project includes a `.g2u` script, you MUST run the gab-test-debug cycle on it.** Building and testing only the DLL does NOT validate the GAB script. The GAB runtime has its own errors (ScreenSU crashes, missing controls, wrong API namespaces, path issues) that only appear when the script runs inside GSS ERP.
- **Do NOT tell the user the project is done until gab-test-debug shows `SCRIPT COMPLETED SUCCESSFULLY`.** A clean DLL build with passing unit tests is step 1. Step 2 is the instrumented GAB script passing through the full test-debug cycle.
- **The user should NEVER be the one to discover a GAB runtime error.** If they see an error dialog, the TDD cycle was incomplete.

# TDD is Collaboration

We are a team - human and AI working together. Tests are our shared language and our institutional memory.

- **Tests capture understanding**: When we figure something out together, a test locks that knowledge in. Neither of us has to remember it - the test remembers for us.
- **Tests enable fearless iteration**: With good test coverage, we can refactor, optimize, and extend without fear. The tests tell us immediately if we broke something.
- **Tests are documentation that runs**: Comments lie, documentation drifts, but tests that pass prove the system works as expected.
- **Tests build trust**: When you write a test first, you're showing your work. I can see what you expect. You can see what I understand. We align before we build.
- **Tests accelerate us**: The upfront investment in TDD pays compound interest. Every test we write makes the next change safer and faster.

Use TDD for everything you can. Bug report? Write a failing test. New feature? Write a failing test. Refactoring? Ensure tests cover the behavior first. Performance concern? Write a benchmark test. 

The goal is a codebase where we can move fast because we have a safety net of tests catching us. Every test is a gift to our future selves.

# TDD Principles

1. **PoC or GTFO**: If you cannot construct a failing test around a hypothesis, then your hypothesis is false. Speculation without a reproducible test is not considered actualized. This applies to all assumptions, bug reports, and feature requests.
2. **Target**: Given a successful hypothesis and its corresponding failing test, you must make the test pass ONLY through a narrow, focused implementation. Until the test passes, you have not implemented a fix.
3. **Triangulation**: You must triangulate with additional tests that modify the scenario to prove the implementation isn't overly specific.
4. **Boundaries**: Two is many, nulls are expected. Always test the boundary conditions (zero, one, many, null, empty, max).
5. **Corner Cases**: Null is expected, comms will be lost, and nothing is guaranteed. What happens give enormous unexpected input? What happens under concurrent access? Consider all considerations.

# ONLY RUN TESTS ONCE. STORE AND ANALYZE THE OUTPUT
- Always redirect test output to a file so you can analyze it without re-running.
- If you need to find failures, grep the output file — do NOT re-run the entire suite.
- If you need counts, error messages, or stack traces, use `grep`, `rg`, or read the XML/HTML reports under `build/test-results/` and `build/reports/tests/`.
- Re-running the full test suite just to extract different information from the same run is wasteful. Run once, analyze many times.

---

# Test Composition
- CRITICAL! NEVER MOCK BUSINESS LOGIC
- CRITICAL! NEVER MOCK HANDLERS
- CRITICAL! NEVER MOCK ROUTING
- CRITICAL! Always use dependency injection for test objects. Do not new up test objects. They should always be registered in a service collection or from a helper factory.
- A mock should only be used when required.
- Never mock the database. We need to test against the database. But only test against the database in integration tests. 

# GAB Script TDD (gab-test-debug)

GAB scripts run inside the GSS ERP process with no stdout/stderr. Use the **gab-test-debug** skill for TDD cycles.

## GAB TDD Rules

1. **Test ALL user-triggerable paths, not just initial load.** If the script has drill-downs, event handlers, button clicks, or URL hash navigation -- instrument and test each path explicitly. The summary screen loading does NOT prove the drill-down works.
2. **Simulate event-driven paths from Main.** GAB events (UrlChanged, CellValueChanged, ButtonClick) cannot be triggered externally. To test them, add a temporary call in Main that invokes the handler subroutine directly with test data, then remove it after verification.
3. **Views-first for all reads.** Always query `V_*` views, never raw tables. Views provide proper typed columns and are the supported read interface.
4. **Verify column names against schema before writing SQL.** Do NOT guess column names. Verify column names against schema: read `agents/schema/` docs, or query `SELECT * FROM dbo.fSQLColumns(NULL,'TABLE_NAME',NULL)` or `CALL psp_columns(NULL,'TABLE_NAME',NULL)` — Actian Zen does not support SQL-standard `INFORMATION_SCHEMA`.
5. **Strip debug calls before delivery.** Remove any `F.Intrinsic.Debug.*` calls you added during testing before signing the production script. If you used custom DebugLog instrumentation (last resort), remove the entire DebugLog subroutine and all CallSub(DebugLog,...) calls.
6. **One TDD iteration = one focused fix.** Do not batch multiple fixes per cycle. Change one thing, re-run, read the log. The log tells you exactly where execution stopped.

## GAB TDD Workflow

```
Read script → Sign → Launch via .gaf (sentinel enables native trace) → Read trace
    → If trace shows error: fix one thing, add SetLA calls if needed, repeat
    → If trace shows success but path untested: add test call for that path, repeat
    → If all paths pass: strip debug calls → sign → deliver
```

Native trace via `octsrs.logging` sentinel is the primary debug mechanism. Use `F.Intrinsic.Debug.SetLA(...)` and other native debug API calls for targeted diagnostics. Custom DebugLog file-based instrumentation is a last resort only.


- NEVER commit and push without running tests locally first.
- If tests fail in CI that passed locally, investigate environment differences.
- This is non-negotiable. Pushing untested code wastes CI resources and blocks deployments.

# Integration tests Prioritize the Fixture
- Integration tests should test a running application
- The application is hosted in the fixture
- Override services in the fixture
- Use context and configuraiton that allows utilizing the application as the fixture

# Target
- An event based service's tests should be driven by emitting events
- An endpoint should be tested at the endpoint

# Events
- There is handling for Events. They should be emitted using EmitAsync

# Polling services

Polling services are hard to test. Generally the best solution is an API endpoint driven by a cron job.

If using a polling service anyway, the solution is to separate concerns:

## Pattern: Thin Polling Service + Testable Emitter

1. **Polling Service** (internal, ~10-15 LOC in ExecuteAsync):
   - Just a timer that calls the emitter on an interval
   - No business logic
   - Not registered in tests (use fixture to exclude hosted services)

2. **Emitter** (internal class with public interface):
   - Contains all the logic for reading data and emitting events
   - Has a public interface because it's an adapter for external systems (e.g., SQL Server CDC)
   - Registered in DI so tests can resolve and call it directly

## Key Rules

- Polling services should emit events
- We do not test polling services directly
- We test the handling of events they emit
- The emitter interface is public because it adapts external systems
- Polling services should only manage polling. The logic run should be in a dependency

# Mocking
- You can use WireMock for an external API
- You should only ever need to mock external unmanaged dependencies (EUDs)
- EUDs should always have an interface. They are a seam. Mock the interface
- The solution for EUDs is mocking with a stub, spy, or bomb mock
- These mocks should be added into the service collection and transparent to the test suite AND the application
- If you need to test output to an EUD, use a spy
- If you need to test input from an EUD, use a stub with randomized data and validation functionality

# Assertions
- Assertions should not be made against magic values.
- If a stub was used to introduce data, it should have a store to validate against.
- All data should be randomized where possible

# CODE FLAGS
CRITICAL! Flag any of the following as architecture flags
- Requiring InternalsVisibleTo
- Making classes public to test
- Probing internal class state instead of spy mocks
- Domain/Unit tests requiring data layer
- Code being in UI
