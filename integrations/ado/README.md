# Azure DevOps integration (read-only)

ArtStack commands read work items through an MCP server for Azure DevOps. ArtStack ships configuration and conventions only; it does not ship or run any server code. Everything runs on your machine with your credentials.

## Setup

1. Create a Personal Access Token in Azure DevOps with **read-only** scopes:
   - Work Items: Read
   - Project and Team: Read
   - Analytics: Read (optional, for iteration/capacity queries)
   Nothing else. No write scopes. Commands draft markdown; humans file changes.
2. Install an Azure DevOps MCP server (Microsoft publishes one; your org may mandate a specific package or an internal mirror; check with your platform team).
3. Add the server to your Claude Code MCP configuration. Template in `mcp.json` in this folder. Keep the PAT in an environment variable, never in the file.
4. Fill in the tracker section of `context/team.md`: organization, project, area path, and the work item hierarchy your train uses.

## Query conventions used by commands

Commands reference work items by ID (e.g. `/pi-prep 12345`) and expect to resolve, via the MCP server:

- The item itself: title, description, acceptance criteria field, state, type
- Its parent chain (story to feature to epic) and children
- Iteration and area path assignments
- WSJF or custom priority fields if your process configures them
- For /demo-prep: items completed in a given iteration for the team's area path
- For /defect: open bugs in the team's area path for duplicate checks

If a field or query is unavailable, commands are instructed to say so and continue with what they have rather than invent values.

## Data handling

- Read-only tokens; ArtStack commands never create, update, comment on, or link work items.
- Work item content goes only into your local session context and to your configured model endpoint (your org's gateway if that is how Claude Code is set up). ArtStack adds no storage, proxy, or telemetry of its own.
- Do not include customer personal data in prompts if your work items contain it; sanitize first.
