#!/usr/bin/env python3
"""Initialise/update an app inventory file from local code and IaC Git repos.

Usage:
  scripts/init-project.py ../my-app ../my-app-iac

When PLATFORM_REPO_URL is set, clones the platform repo, applies the change,
renders the ApplicationSet, and opens a GitLab MR instead of writing directly
to the local filesystem.
"""

import os
import sys

if os.environ.get("PLATFORM_REPO_URL"):
    from platform_git import create_mr_for_init
    create_mr_for_init(sys.argv)
else:
    from init_projects.cli import main
    main()
