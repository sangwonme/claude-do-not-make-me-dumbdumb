# Environment guide

How to set up the one Docker dev environment, and the test and operate tools per stack. Skills point here when §6 Container, Test, or Operate is missing what they need.

Recording choices: the developer's answers go into §6 only through a proposal (`.claude/guides/proposal.md`). Never edit the spec.

## Container

One image for `Codes/` and every `PoC/`. Set it up when §6 Container is empty.

1. Ask the developer in one AskUserQuestion call: base image (offer the official image for §6 Stack first; if a scenario's Then is seen in a browser, also the browser-testing image for that language), and ports the app listens on.
2. Write at the repo root:
   - `Dockerfile`: `FROM <their base>`, `WORKDIR /work`, then dependency installs. Main-code dependencies come from the manifest in `Codes/` (copy it in and install). Each PoC-only dependency is its own install line ending in a `# poc: <name>` comment, so `/poc merge` can move it into the manifest and a dropped PoC's lines can be found and removed.
   - `compose.yaml`: one service `dev`, `build: .`, the repo mounted at `/work`, `working_dir: /work`, the ports. Package managers that install into the project folder (for example `node_modules`) get an anonymous volume at that path so the host copy never shadows the image's.
3. Build, then check `docker compose run --rm dev <a version command>` works.
4. Propose for §6 Container: `docker compose run --rm --service-ports dev` as the prefix for the main code, and `docker compose run --rm -w /work/PoC/<name> dev` for a PoC.

Rules:
- Every Run and Test command runs through the prefix. Never install on the host.
- Adding or removing a dependency means editing `Dockerfile` or the `Codes/` manifest (ask first), then rebuilding.
- Tools that drive the app from outside (browser automation, an MCP server) run on the host against the published port.
- Host-only stacks: a device or emulator for mobile, a game engine editor, or desktop GUI windows cannot run reasonably in Docker. Run those on the host only if the developer says so; the proposal for §6 Container then says `host` and why, and dependencies still live in a manifest.

## Test and operate tools

Set up when §6 Test cannot check a scenario's Then (usually something the user sees), or §6 Operate is empty.

1. Find the row for §6 Stack. Ask the developer to pick the tool (AskUserQuestion, options from that row, first one recommended).
2. Install only after that answer, into the image. Check the tool's current install command (`--help` or its docs) rather than trusting this file's; they change.
3. Point the runner at `Codes/Test/`. Unit and E2E tests both live there; split into `Codes/Test/unit/` and `Codes/Test/e2e/` only once both exist.
4. One E2E test per scenario, named with its ID. Drive it through the UI the user touches; assert the Then the user would see.
5. Propose the new §6 Test and Operate lines. Install nothing for a stack not listed until the developer confirms the tool.

| Stack | E2E test tool | Point at `Codes/Test/` | Operate in use sessions (capture) |
|---|---|---|---|
| Web (any JS framework) | Playwright Test; browser-testing image as base | `playwright.config`: `testDir: './Codes/Test'`, `webServer.command` = §6 Run | Playwright MCP or a browser extension on the host; screenshots |
| Python web (Flask, Django, FastAPI) | pytest + pytest-playwright; browser-testing image as base | `pyproject.toml`: `[tool.pytest.ini_options] testpaths = ["Codes/Test"]` | Same as web |
| Streamlit / Gradio | Streamlit: `streamlit.testing.v1.AppTest` (headless). Gradio: pytest-playwright | Same as Python | Same as web |
| Electron | Playwright `_electron.launch()` (needs a virtual display in the container, or host) | Same as web, no `webServer` | Playwright; screenshots |
| Desktop Python (Qt) | pytest-qt (`qtbot`), offscreen platform in the container | Same as Python | Host: developer plays; you capture with an OS screenshot tool |
| Desktop Python (Tkinter) | pytest, calling widget commands and `event_generate`, with a virtual display | Same as Python | Same as Qt |
| Mobile (React Native, Flutter, native) | Host-only. Maestro (YAML flows). Flutter alternative: `integration_test`. Native: XCUITest / Espresso | `maestro test Codes/Test/`; Flutter: `flutter test Codes/Test/e2e -d <device>`; XCUITest / Espresso live in the Xcode / Gradle test target: propose its path for §6 | Maestro (`maestro studio`) or developer plays on a device; screenshots |
| Unity | Host-only. Unity Test Framework, PlayMode tests | Must be under `Assets/`: `Assets/Test/` with its own asmdef; propose the path for §6 | Unity MCP; screenshots |
| CLI | The language's test runner, running the CLI as a subprocess; assert stdout and exit code. Shell: bats | Runner pointed at `Codes/Test/` | Run it through the prefix; save the terminal output as `.txt` |
| HTTP API | The language's test runner + HTTP client (supertest, httpx / FastAPI `TestClient`) | Runner pointed at `Codes/Test/` | Requests from the host to the published port; save request and response as `.txt` |
| Unit tests only (JS) | Vitest or Jest | Vitest `test.include: ['Codes/Test/**']`; Jest `roots: ['<rootDir>/Codes/Test']` | n/a |

### Apps with model or random output (LLM, generative, sensors)

The same When can give a different Then. Assert what the developer's Then guarantees (structure, presence, range, ordering), not exact text. For a deterministic run, stub the model call in the test; keep one unstubbed E2E test per scenario and mark it slow. If the Then cannot be checked by a machine at all, it is a use-session finding, not a test: say so in `test.md`.
