# Terraform Safe MCP Server - Installation Status

## ✅ Installation Complete!

The Terraform Safe MCP server has been successfully:

1. **Created** - All source files written to `/Users/zapzap/.config/opencode/mcp-servers/terraform-safe/`
2. **Dependencies Installed** - npm packages installed successfully
3. **Built** - TypeScript compiled to JavaScript in `dist/` directory
4. **Registered** - Added to OpenCode configuration at `opencode.json`

## Configuration

The MCP server has been added to your OpenCode config:

```json
"terraform-safe": {
  "type": "local",
  "command": ["node", "/Users/zapzap/.config/opencode/mcp-servers/terraform-safe/dist/index.js"]
}
```

## Next Steps

### 1. Restart OpenCode

For the new MCP server to be loaded, you need to restart OpenCode:

```bash
# If OpenCode is running, stop it and start again
# The exact command depends on how you run OpenCode
```

### 2. Verify the Tool is Available

After restart, the following tools should be available:

- `mcp_terraform_safe_exec` - Execute safe Terraform commands
- `mcp_terraform_check_version` - Check if Terraform is installed

### 3. Test the Blocking

Try to execute `terraform apply` - it should be **BLOCKED**:

The tool will reject it with:
```
❌ Error: Command 'terraform apply' is blocked for safety. 
   This command can modify infrastructure and requires 
   manual execution with proper approvals.
```

### 4. Test Allowed Commands

Try to execute `terraform plan` - it should work (after confirmation):

1. First call will ask for confirmation
2. Set `confirmed: true` to execute
3. Should run successfully (if Terraform is installed)

## Blocked Commands

These commands are **hardcoded as blocked**:
- ❌ `terraform apply`
- ❌ `terraform destroy`
- ❌ `terraform import`
- ❌ `terraform taint`
- ❌ `terraform untaint`
- ❌ `terraform force-unlock`

## Allowed Commands

These commands are **whitelisted**:
- ✅ `terraform plan`
- ✅ `terraform validate`
- ✅ `terraform init`
- ✅ `terraform fmt`
- ✅ `terraform show`
- ✅ `terraform output`
- ✅ `terraform state list`
- ✅ `terraform state show`
- ✅ `terraform version`
- ✅ `terraform graph`
- ✅ `terraform workspace list`
- ✅ `terraform workspace show`

## Files Created

```
~/.config/opencode/mcp-servers/terraform-safe/
├── src/
│   └── index.ts           # Main MCP server code
├── dist/                  # Compiled JavaScript
│   ├── index.js
│   ├── index.js.map
│   ├── index.d.ts
│   └── index.d.ts.map
├── node_modules/          # Dependencies
├── package.json           # Project configuration
├── tsconfig.json          # TypeScript configuration
├── README.md              # Full documentation
├── INSTALL.md             # Installation guide
├── example-agent.md       # Example agent using this tool
├── .gitignore
└── STATUS.md              # This file
```

## Troubleshooting

If the tool doesn't appear after restart:

1. Check OpenCode logs for MCP connection errors
2. Verify the path in `opencode.json` is correct
3. Ensure `dist/index.js` exists
4. Try running manually: `node dist/index.js` (should say "running on stdio")

## Security Notes

- The blocking is at the **tool execution level**, not AI instruction level
- Even if an AI agent tries to call `terraform apply`, it will be rejected
- This cannot be bypassed through prompt engineering
- All command attempts are logged to stderr

## Transferring to Work Machine

To use this on another machine:

1. Copy the entire `terraform-safe/` directory
2. Run `npm install` and `npm run build`
3. Add to that machine's OpenCode config
4. Restart OpenCode

Date Installed: 2026-02-08
