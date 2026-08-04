# Jira integration (read-only)

ArtStack commands read Jira issues through an MCP server. As with Azure DevOps, ArtStack ships configuration and conventions only. Status: template provided; marked community-validated once external users confirm it against a live Jira instance (our own dogfooding runs on Azure DevOps).

## Setup

1. Create an API token for your Atlassian account. Grant read-only access: Jira scopes for reading issues, projects, and boards. No write scopes.
2. Install a Jira MCP server (Atlassian publishes an official remote MCP server; self-managed options exist; check what your org allows).
3. Add the server to your Claude Code MCP configuration. Template in `mcp.json` in this folder. Token in an environment variable, never in the file.
4. Fill in the tracker section of `context/team.md`: site URL, project key, and the issue hierarchy your train uses (e.g. Epic > Story, or a portfolio tool layer above).

## Query conventions used by commands

Commands reference issues by key (e.g. `/pi-prep PORT-123`) and expect to resolve:

- The issue: summary, description, acceptance criteria (field or description section), status, type
- Parent/child links (epic link or parent field, depending on your setup)
- Sprint and board assignment
- Priority or WSJF-equivalent custom fields if configured
- For /demo-prep: issues completed in a given sprint for the team's board
- For /defect: open bugs in the project for duplicate checks

If your Jira hierarchy differs from the default (many do), document the mapping in team.md's work item conventions section; commands read it from there.

## Data handling

Same rules as the Azure DevOps integration: read-only, no write-back, no ArtStack-side storage or telemetry, sanitize personal data before it enters prompts.
