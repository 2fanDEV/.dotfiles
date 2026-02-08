# Troubleshooting

Source: https://developer.atlassian.com/cloud/acli/guides/troubleshooting-guide/

## Help

```bash
acli help
acli help jira workitem create
acli jira --help
acli jira workitem create --help
```

## Common flags

- `--ignore-errors`: continue bulk operations even if one item fails.
- `--json`: output results to a JSON file (when supported).
- `--generate-input-json` / `--generate-json`: emit a template JSON input for commands that accept JSON-driven workflows.

## Trace IDs

Unexpected backend errors include a trace ID:

```
unexpected error, trace id: XXXXXXXX
```

Save the trace ID; include it in Atlassian support requests.
