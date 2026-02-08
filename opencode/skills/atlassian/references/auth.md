# Authentication (Jira / Admin / Rovo Dev)

Source: https://developer.atlassian.com/cloud/acli/guides/how-to-get-started/

## Jira auth with API token (non-interactive)

Generate an API token:
https://id.atlassian.com/manage-profile/security/api-tokens

Examples (token via stdin). Avoid placing the token directly in the command line.

```bash
# Jira
printf '%s' "$ATLASSIAN_API_TOKEN" | acli jira auth login --site "$JIRA_SITE_URL:" --email "$EMAIL_ADRESS" --token

# Rovo Dev
printf '%s' "$ATLASSIAN_API_TOKEN" | acli rovodev auth login --site "$JIRA_SITE_URL:" --email "$EMAIL_ADRESS" --token
```

## Jira auth with OAuth (interactive)

```bash
acli jira auth login --web
```

## Admin auth with API key

Admin commands require an API key:
https://support.atlassian.com/organization-administration/docs/manage-an-organization-with-the-admin-apis/
