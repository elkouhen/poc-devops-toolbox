#!/usr/bin/env python3
"""Deprecated: onboarding passe desormais par une pull/merge request directe.

Ouvrir une PR/MR sur `platform-gitops` ajoutant `argocd/apps/<app>.yaml`
(name, description, services) au lieu d'appeler ce script.
"""

import sys

print(
    "init-project.py est deprecie : cree argocd/apps/<app>.yaml sur une "
    "branche et ouvre la pull/merge request directement sur platform-gitops.",
    file=sys.stderr,
)
sys.exit(1)
