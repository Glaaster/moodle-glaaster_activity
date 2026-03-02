// Dangerfile (danger-js, GitHub adapter)

// Rule 1: PR title must follow Conventional Commits
const conventionalCommitRegex =
  /^(build|ci|docs|feat|fix|perf|refactor|style|test|chore)(\([a-zA-Z0-9_\-]+\))?: .+/;

if (!danger.github.pr.title.match(conventionalCommitRegex)) {
  fail(
    'The Pull Request title does not follow the Conventional Commit convention. ' +
    'It should start with a type (e.g., `feat`, `fix`, etc.) followed by a concise description. ' +
    'See https://www.conventionalcommits.org/en/v1.0.0/ for more details.'
  );
}

// Rule 2: Commit message body lines must not exceed 100 characters
danger.git.commits.forEach((commit) => {
  const lines = commit.message.split('\n').slice(1); // skip header
  lines.forEach((line) => {
    if (line.length > 100) {
      fail(
        `Commit message body lines should not exceed 100 characters. ` +
        `Please reformat commit: ${commit.sha}`
      );
    }
  });
});
