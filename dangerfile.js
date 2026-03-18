// dangerfile.js
const { danger, warn, message } = require('danger');

const pr = danger.github.pr;
const commits = danger.git.commits;

// --- PR description check ---
if (!pr.body || pr.body.trim().length === 0) {
  warn('Please add a description to your PR.');
}

// --- Jira ticket check ---
const jiraKeys = process.env.JIRA_KEYS;
const jiraUrl = process.env.JIRA_URL;

if (jiraKeys && jiraUrl) {
  const keys = jiraKeys.split(',').map((k) => k.trim()).filter(Boolean);
  const jiraPattern = new RegExp(`(${keys.join('|')})-\\d+`, 'i');

  const titleHasTicket = jiraPattern.test(pr.title);
  const bodyHasTicket = jiraPattern.test(pr.body || '');
  const commitHasTicket = commits.some((c) => jiraPattern.test(c.message));

  if (!titleHasTicket && !bodyHasTicket && !commitHasTicket) {
    warn(
      `No Jira ticket found. Please reference a ticket (e.g. ${keys[0]}-123) in your PR title, description, or a commit message. [Browse tickets](${jiraUrl})`
    );
  } else {
    const match = (pr.title + ' ' + (pr.body || '')).match(jiraPattern);
    if (match) {
      message(`Jira ticket: [${match[0]}](${jiraUrl}/browse/${match[0]})`);
    }
  }
}

// --- Big PR warning ---
const changedFiles = danger.git.created_files.length + danger.git.modified_files.length + danger.git.deleted_files.length;
if (changedFiles > 30) {
  warn(`This PR touches ${changedFiles} files. Consider splitting it into smaller PRs.`);
}
