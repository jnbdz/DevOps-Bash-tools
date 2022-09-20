#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2021-11-28 11:11:51 +0000 (Sun, 28 Nov 2021)
#
#  https://github.com/HariSekhon/DevOps-Bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists GitHub Actions Workflows enabled/disable state via the API

Output format:

<workflow_id>    <enabled/disable>   <workflow_name>


To scan all repos to find any disabled workflows, such as developers disabling code scanning workflows that are bugging them in PRs, do:

    github_foreach_repo.sh github_actions_workflows_disabled.sh {owner}/{repo}
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo> [<workflow_id>]"

help_usage "$@"

"$srcdir/github_actions_workflows.sh" "$@" |
jq -r '.workflows[] | select(.state != "active") | [.id, .state, .name ] | @tsv'
