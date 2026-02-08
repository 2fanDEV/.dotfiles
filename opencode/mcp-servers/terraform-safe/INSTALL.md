# Installation Guide - Terraform Safe MCP Server

## Step-by-Step Installation

### Step 1: Install Dependencies

```bash
cd ~/.config/opencode/mcp-servers/terraform-safe
npm install
```

This will install:
- `@modelcontextprotocol/sdk` - MCP SDK
- TypeScript and build tools

### Step 2: Build the Server

```bash
npm run build
```

This compiles TypeScript to JavaScript in the `dist/` directory.

### Step 3: Test the Server (Optional)

Verify it works:

```bash
npm run dev
```

You should see:
```
Terraform Safe MCP Server running on stdio
Allowed commands: plan, validate, init, ...
Blocked commands: apply, destroy, import, ...
```

Press `Ctrl+C` to stop.

### Step 4: Configure OpenCode

You need to register this MCP server with OpenCode. The configuration location depends on your OpenCode setup.

#### Option A: Using opencode.json

If you have `~/.config/opencode/opencode.json`:

```json
{
  "mcpServers": {
    "terraform-safe": {
      "command": "node",
      "args": [
        "/Users/zapzap/.config/opencode/mcp-servers/terraform-safe/dist/index.js"
      ]
    }
  }
}
```

#### Option B: Using OpenCode CLI

If OpenCode has a CLI for registering MCP servers:

```bash
opencode mcp add terraform-safe \
  --command node \
  --args /Users/zapzap/.config/opencode/mcp-servers/terraform-safe/dist/index.js
```

#### Option C: Check OpenCode Documentation

Look for how OpenCode discovers MCP servers. It might:
- Auto-discover from `~/.config/opencode/mcp-servers/`
- Use a config file in a different location
- Have its own registration system

### Step 5: Restart OpenCode

After configuration:

```bash
# Stop OpenCode if running
# Then start it again
opencode
```

### Step 6: Verify Installation

Check if the MCP server is loaded:

1. Look for "terraform-safe" in available MCP servers
2. Check OpenCode logs for connection messages
3. Try using the tool from an agent

## Verification Test

Create a test agent or use the OpenCode console:

```typescript
// Test if tool is available
tools.terraform_check_version()

// Expected output: Terraform version information or "not installed"
```

## Troubleshooting

### Problem: "Module not found" errors

**Solution:**
```bash
cd ~/.config/opencode/mcp-servers/terraform-safe
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Problem: "Cannot find module '@modelcontextprotocol/sdk'"

**Solution:** Make sure you're using Node.js 18 or later:
```bash
node --version  # Should be v18.x or higher
```

### Problem: OpenCode doesn't see the MCP server

**Solution:** 
1. Check OpenCode logs for errors
2. Verify the path in your config is absolute and correct
3. Make sure `dist/index.js` exists after building
4. Try restarting OpenCode completely

### Problem: "Terraform is not installed"

**Solution:**
```bash
# Install Terraform
brew install terraform  # macOS
# or
sudo apt install terraform  # Ubuntu
# or download from https://terraform.io

# Verify
terraform version
```

## Next Steps

After installation, create an agent that uses this tool. See `example-agent.md` for a template.

## Uninstallation

To remove:

```bash
# Remove from OpenCode config
# (edit your opencode.json or use CLI)

# Delete the directory
rm -rf ~/.config/opencode/mcp-servers/terraform-safe
```
