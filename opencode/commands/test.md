---
description: Intelligently detect and run project tests with detailed reporting
agent: test-runner
model: anthropic/claude-sonnet-4-5
---

Execute the project's test suite by following this structured approach:

## Phase 1: Test Configuration Discovery
Automatically detect test configuration and setup:
1. Search for test configuration files (package.json scripts, pytest.ini, go.mod, Cargo.toml, etc.)
2. Identify the technology stack and testing framework
3. Determine the appropriate package manager (npm/yarn/pnpm/bun/pip/cargo/go)
4. Locate test directories and test files

## Phase 2: Test Execution
Run tests with appropriate flags for maximum insight:
- Execute with coverage reporting when available (--coverage, --cov, etc.)
- Use verbose output to capture detailed failure information
- Capture both stdout and stderr for complete diagnostics
- Set appropriate timeout values for long-running test suites

## Phase 3: Results Analysis & Reporting
Provide comprehensive test results:
1. **Summary Statistics**: Total tests, passed, failed, skipped, execution time
2. **Failure Details**: For each failing test, show:
   - Test name and location (file path, line number)
   - Failure message and stack trace
   - Expected vs actual values
   - Relevant code context
3. **Coverage Report**: If available, show coverage percentages by file/module
4. **Actionable Insights**: Identify patterns in failures (e.g., similar errors across multiple tests)

## Phase 4: Fix Suggestions (if failures detected)
For failing tests, provide:
- Root cause analysis of each failure
- Specific code fixes with file paths and line numbers
- Explanation of why the test failed and how the fix addresses it
- Consideration of edge cases that might have been missed

## Best Practices
- Always run from project root directory
- Respect existing CI/CD test configurations
- Don't modify test files or configurations without explicit permission
- Use cached dependencies when available for faster execution
- Fail fast on environment/dependency issues with clear setup instructions