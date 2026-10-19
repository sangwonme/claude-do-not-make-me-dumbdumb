# E2E setup guide

How to test and operate the app per stack, so `/qa` (test team and use sessions) and `/restructure` can run. Read this when the spec's §6 Test or Operate is missing what a scenario needs, usually because a Then is something the user sees.

## Rules

- Find the row for §6 Stack. Ask the developer to pick the tool (AskUserQuestion, options from that row, first one recommended). Record their choice in §6 Test / Operate exactly as answered.
- Install only after that answer, as a dev dependency, with the project's own package manager. Check the tool's current install command (`--help` or its docs) rather than trusting this file's; they change.
- Point the runner at `Test/` (the "Test/ config" column). Unit and E2E tests both live there; split into `Test/unit/` and `Test/e2e/` only once both exist.
- One E2E test per scenario, named with its ID. Drive it through the UI the user touches, assert the Then the user would see.
- Install nothing for a stack not listed until the developer confirms the tool.

## By stack

| Stack | E2E test tool | Test/ config | Operate in use sessions (capture) |
|---|---|---|---|
| Web (any JS framework) | Playwright Test (`npm init playwright@latest`) | `playwright.config`: `testDir: './Test'`, `webServer.command` = §6 Run | Playwright MCP or a browser extension; screenshots |
| Python web (Flask, Django, FastAPI) | pytest + pytest-playwright (`playwright install` after) | `pyproject.toml`: `[tool.pytest.ini_options] testpaths = ["Test"]` | Same as web |
| Streamlit / Gradio | Streamlit: `streamlit.testing.v1.AppTest` (headless). Gradio: pytest-playwright | Same as Python | Same as web |
| Electron | Playwright `_electron.launch()` | Same as web, no `webServer` | Playwright; screenshots |
| Desktop Python (Qt) | pytest-qt (`qtbot`) | Same as Python | Developer plays; you capture with an OS screenshot tool |
| Desktop Python (Tkinter) | pytest, calling widget commands and `event_generate` | Same as Python | Same as Qt |
| Mobile (React Native, Flutter, native) | Maestro (YAML flows, folder-agnostic). Flutter alternative: `integration_test`. Native alternatives: XCUITest / Espresso | `maestro test Test/`; Flutter: `flutter test Test/e2e -d <device>`; XCUITest / Espresso must live in the Xcode / Gradle test target: write its path in §6 | Maestro (`maestro studio`) or developer plays on a device; screenshots |
| Unity | Unity Test Framework, PlayMode tests | Must be under `Assets/`: use `Assets/Test/` with its own asmdef, and write the path in §6 | Unity MCP; screenshots |
| CLI | The language's test runner, running the CLI as a subprocess; assert stdout and exit code. Shell: bats | Runner pointed at `Test/` | Run it; save the terminal output as `.txt` |
| HTTP API | The language's test runner + HTTP client (supertest, httpx / FastAPI `TestClient`) | Runner pointed at `Test/` | Requests in a shell; save request and response as `.txt` |
| Unit tests only (JS) | Vitest or Jest | Vitest `test.include: ['Test/**']`; Jest `roots: ['<rootDir>/Test']` | n/a |

## Apps with model or random output (LLM, generative, sensors)

The same When can give a different Then. Assert what the developer's Then guarantees (structure, presence, range, ordering), not exact text. For a deterministic run, stub the model call in the test; keep one unstubbed E2E test per scenario and mark it slow. If the Then cannot be checked by a machine at all, it is a use-session finding, not a test: say so in `test.md`.
