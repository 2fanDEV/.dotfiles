# Terraform Safe Execution MCP Server

A Model Context Protocol (MCP) server that provides safe Terraform command execution by blocking dangerous operations like `apply` and `destroy`.

## Features

✅ **Whitelist Approach**: Only approved commands can be executed  
✅ **Hard Blocks**: `terraform apply` and `terraform destroy` are blocked at the tool level  
✅ **User Confirmation**: Requires explicit user approval before executing any command  
✅ **Audit Logging**: All command attempts are logged to stderr  
✅ **Read-Only Operations**: Focus on planning and validation  

## Allowed Commands

- `terraform plan` - Show what changes will be made
- `terraform validate` - Validate configuration syntax
- `terraform init` - Initialize working directory
- `terraform fmt` - Format Terraform files
- `terraform show` - Show current state or plan
- `terraform output` - Show output values
- `terraform state list/show` - Read-only state operations
- `terraform version` - Show Terraform version
- `terraform graph` - Generate dependency graph
- `terraform workspace list/show` - List and show workspaces

## Blocked Commands

❌ `terraform apply` - Blocked for safety  
❌ `terraform destroy` - Blocked for safety  
❌ `terraform import` - Modifies state  
❌ `terraform taint/untaint` - Modifies state  
❌ `terraform force-unlock` - Can cause corruption  

## Installation

### 1. Install Dependencies

```bash
cd ~/.config/opencode/mcp-servers/terraform-safe
npm install
```

### 2. Build the Server

```bash
npm run build
```

### 3. Configure OpenCode to Use This MCP Server

Add to your OpenCode configuration (typically `~/.config/opencode/opencode.json` or similar):

```json
{
  "mcpServers": {
    "terraform-safe": {
      "command": "node",
      "args": [
        "/Users/zapzap/.config/opencode/mcp-servers/terraform-safe/dist/index.js"
      ],
      "env": {}
    }
  }
}
```

### 4. Restart OpenCode

Restart OpenCode to load the new MCP server.

## Usage

### From an Agent

Create an agent that uses this tool:

```yaml
---
description: Terraform infrastructure agent (safe execution only)
mode: primary
model: anthropic/claude-sonnet-4-5
tools:
  bash: false  # No bash needed!
  read: true
  write: false
---

You are a Terraform Infrastructure Assistant.

You have access to the terraform_safe_exec tool which allows you to:
- Run terraform plan
- Validate configurations
- Show state and outputs
- Format files

You CANNOT run terraform apply or destroy - these are hardcoded blocks.

Always ask the user for confirmation before executing any terraform command.
```

### Example Interactions

**Planning:**
```
User: "Run terraform plan for my infrastructure"

Agent: "I'll run terraform plan for you."
[Uses terraform_safe_exec with command="plan"]
[Tool asks for confirmation]
Agent: "Do you want to execute: terraform plan?"
User: "Yes"
[Command executes]
Agent: "Here's the plan output: ..."
```

**Blocked Command:**
```
User: "Apply the terraform changes"

Agent: "I cannot execute terraform apply - this command is blocked for safety."
[If agent tries to call tool with command="apply"]
[Tool returns error: "Command 'terraform apply' is blocked for safety"]
```

## Development

### Watch Mode (for development)

```bash
npm run watch
```

### Run Directly (for testing)

```bash
npm run dev
```

## Security Features

1. **Whitelist Validation**: Only explicitly allowed commands pass validation
2. **Argument Scanning**: Scans arguments for blocked commands
3. **User Confirmation**: Every command requires `confirmed: true`
4. **No Bash Escape**: Agent doesn't need bash access
5. **Audit Trail**: All commands logged to stderr

## Architecture

```
User Request
    ↓
OpenCode Agent
    ↓
terraform_safe_exec MCP Tool
    ↓
Command Validation (whitelist check)
    ↓
User Confirmation Required
    ↓
Execute Terraform CLI
    ↓
Return Output
```

## Error Handling

The tool provides clear error messages:

- `"Command 'terraform apply' is blocked for safety..."` - Blocked command
- `"Command 'terraform xyz' is not in the approved command list..."` - Unknown command
- `"Terraform is not installed or not in PATH..."` - Terraform not found
- `"Terraform command failed (exit code 1)..."` - Command execution error

## License

MIT

## Contributing

This is a safety-critical tool. When adding new features:

1. **Never** add `apply` or `destroy` to the allowed list
2. **Always** validate new commands for safety
3. **Always** require user confirmation
4. **Always** log command attempts

## Troubleshooting

### "Terraform is not installed"

Make sure Terraform is installed and in your PATH:

```bash
which terraform
terraform version
```

### "MCP server not connecting"

Check OpenCode logs for connection errors. Verify the path in your config is correct.

### "Command is blocked but should be allowed"

Check the `ALLOWED_COMMANDS` array in `src/index.ts` and add your command if it's safe.
