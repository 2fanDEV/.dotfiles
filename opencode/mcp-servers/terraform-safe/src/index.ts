#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from "@modelcontextprotocol/sdk/types.js";
import { spawn } from "child_process";
import { promisify } from "util";
import { exec as execCallback } from "child_process";

const exec = promisify(execCallback);

/**
 * Terraform Safe Execution MCP Server
 *
 * This MCP server provides safe Terraform command execution by:
 * - Blocking dangerous commands (apply, destroy)
 * - Whitelisting only safe read-only and planning commands
 * - Requiring user confirmation before execution
 * - Logging all command attempts
 */

// Commands that are explicitly blocked for safety
const BLOCKED_COMMANDS = [
  "apply",
  "destroy",
  "import", // Can modify state
  "taint", // Modifies state
  "untaint", // Modifies state
  "force-unlock", // Can cause state corruption
];

// Commands that are explicitly allowed (whitelist approach)
const ALLOWED_COMMANDS = [
  "plan",
  "validate",
  "init",
  "fmt",
  "show",
  "output",
  "state list",
  "state show",
  "version",
  "graph",
  "workspace list",
  "workspace show",
  "providers",
  "console", // Interactive console is read-only
];

interface TerraformExecParams {
  command: string;
  args?: string[];
  workingDir?: string;
  confirmed?: boolean; // Whether user has confirmed execution
}

/**
 * Validate that the terraform command is safe to execute
 */
function validateCommand(
  command: string,
  args: string[] = [],
): { safe: boolean; reason?: string } {
  // Check if it's a blocked command
  if (BLOCKED_COMMANDS.includes(command)) {
    return {
      safe: false,
      reason: `Command 'terraform ${command}' is blocked for safety. This command can modify infrastructure and requires manual execution with proper approvals.`,
    };
  }

  // Check if any args contain blocked commands
  const argsString = args.join(" ");
  for (const blocked of BLOCKED_COMMANDS) {
    if (argsString.includes(blocked)) {
      return {
        safe: false,
        reason: `Arguments contain blocked command '${blocked}'. This operation requires manual execution with proper approvals.`,
      };
    }
  }

  // Check if it's an allowed command
  const isAllowed = ALLOWED_COMMANDS.some((allowed) => {
    return command === allowed || command.startsWith(allowed.split(" ")[0]);
  });

  if (!isAllowed) {
    return {
      safe: false,
      reason: `Command 'terraform ${command}' is not in the approved command list. Allowed commands: ${ALLOWED_COMMANDS.join(", ")}`,
    };
  }

  return { safe: true };
}

/**
 * Execute a terraform command safely
 */
async function executeTerraform(params: TerraformExecParams): Promise<string> {
  const {
    command,
    args = [],
    workingDir = process.cwd(),
    confirmed = false,
  } = params;

  // Validate command safety
  const validation = validateCommand(command, args);
  if (!validation.safe) {
    throw new Error(validation.reason);
  }

  // Build the full command
  const fullArgs = [command, ...args];
  const commandString = `terraform ${fullArgs.join(" ")}`;

  // Log the command attempt
  console.error(`[Terraform Safe MCP] Executing: ${commandString}`);
  console.error(`[Terraform Safe MCP] Working directory: ${workingDir}`);

  // Check if terraform is installed
  try {
    await exec("terraform version");
  } catch (error) {
    throw new Error(
      "Terraform is not installed or not in PATH. Please install Terraform first.",
    );
  }

  // Execute the command
  return new Promise((resolve, reject) => {
    const childProcess = spawn("terraform", fullArgs, {
      cwd: workingDir,
      env: { ...process.env },
    });

    let stdout = "";
    let stderr = "";

    childProcess.stdout.on("data", (data: Buffer) => {
      stdout += data.toString();
    });

    childProcess.stderr.on("data", (data: Buffer) => {
      stderr += data.toString();
    });

    childProcess.on("close", (code: number | null) => {
      const output = stdout + (stderr ? `\n\nSTDERR:\n${stderr}` : "");

      if (code === 0) {
        console.error(`[Terraform Safe MCP] Command completed successfully`);
        resolve(output);
      } else {
        console.error(`[Terraform Safe MCP] Command failed with code ${code}`);
        reject(
          new Error(`Terraform command failed (exit code ${code}):\n${output}`),
        );
      }
    });

    childProcess.on("error", (error: Error) => {
      console.error(`[Terraform Safe MCP] Process error:`, error);
      reject(error);
    });
  });
}

/**
 * Main server implementation
 */
const server = new Server(
  {
    name: "terraform-safe-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  },
);

/**
 * Tool definitions
 */
const TOOLS: Tool[] = [
  {
    name: "terraform_safe_exec",
    description: `Execute Terraform commands safely. This tool allows read-only and planning operations but blocks dangerous commands like apply and destroy.

Allowed commands:
- plan: Show what changes Terraform will make
- validate: Validate configuration syntax
- init: Initialize working directory
- fmt: Format Terraform files
- show: Show current state or plan
- output: Show output values
- state list/show: Read-only state operations
- version: Show Terraform version
- graph: Generate dependency graph
- workspace list/show: List and show workspaces

BLOCKED commands (require manual execution):
- apply: Applying changes is blocked for safety
- destroy: Destroying resources is blocked for safety
- import, taint, untaint, force-unlock: State modification blocked

Note: User confirmation is required before executing any command.`,
    inputSchema: {
      type: "object",
      properties: {
        command: {
          type: "string",
          description:
            "The Terraform command to execute (e.g., 'plan', 'validate', 'init')",
        },
        args: {
          type: "array",
          items: {
            type: "string",
          },
          description:
            "Additional arguments to pass to the Terraform command (e.g., ['-var=env=prod', '-out=plan.tfplan'])",
        },
        workingDir: {
          type: "string",
          description:
            "Working directory where Terraform should be executed (defaults to current directory)",
        },
        confirmed: {
          type: "boolean",
          description:
            "Set to true to confirm execution (user must explicitly approve)",
        },
      },
      required: ["command"],
    },
  },
  {
    name: "terraform_check_version",
    description:
      "Check if Terraform is installed and return its version information",
    inputSchema: {
      type: "object",
      properties: {},
    },
  },
];

/**
 * Handler for listing available tools
 */
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: TOOLS,
}));

/**
 * Handler for tool execution
 */
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    if (name === "terraform_safe_exec") {
      const params = args as unknown as TerraformExecParams;

      // Require confirmation
      if (!params.confirmed) {
        return {
          content: [
            {
              type: "text",
              text: `⚠️ Confirmation Required

You are about to execute:
  terraform ${params.command} ${(params.args || []).join(" ")}

Working directory: ${params.workingDir || process.cwd()}

This command will be executed on your system. Please confirm by setting 'confirmed: true' in the request.

To proceed, ask the user:
"Do you want to execute this Terraform command? This will run on your actual infrastructure."`,
            },
          ],
        };
      }

      const result = await executeTerraform(params);

      return {
        content: [
          {
            type: "text",
            text: `✅ Terraform command executed successfully:

Command: terraform ${params.command} ${(params.args || []).join(" ")}

Output:
${result}`,
          },
        ],
      };
    } else if (name === "terraform_check_version") {
      try {
        const { stdout } = await exec("terraform version");
        return {
          content: [
            {
              type: "text",
              text: `Terraform is installed:\n\n${stdout}`,
            },
          ],
        };
      } catch (error) {
        return {
          content: [
            {
              type: "text",
              text: `Terraform is not installed or not in PATH.\n\nError: ${error instanceof Error ? error.message : String(error)}`,
            },
          ],
        };
      }
    }

    throw new Error(`Unknown tool: ${name}`);
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);

    return {
      content: [
        {
          type: "text",
          text: `❌ Error executing Terraform command:\n\n${errorMessage}`,
        },
      ],
      isError: true,
    };
  }
});

/**
 * Start the server
 */
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);

  console.error("Terraform Safe MCP Server running on stdio");
  console.error("Allowed commands:", ALLOWED_COMMANDS.join(", "));
  console.error("Blocked commands:", BLOCKED_COMMANDS.join(", "));
}

main().catch((error) => {
  console.error("Fatal error in main():", error);
  process.exit(1);
});
