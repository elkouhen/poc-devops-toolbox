SHELL := /bin/bash -e -o pipefail
.SHELLFLAGS := -e -o pipefail -c

GITLAB_DOMAIN           ?= 192.168.33.100.nip.io
PLATFORM_REPO_ROOT ?= $(abspath ../platform-gitops)
PLATFORM_REPO_URL ?=
GITHUB_TOKEN      ?=
GITLAB_TOKEN      ?=
ARGOCD_NAMESPACE  ?= argocd
GITLAB_NAMESPACE  ?= gitlab

.PHONY: help init-project argocd-repo-creds get-gitlab-token check-app-gitlab-ci

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

init-project: ## Deprecated: ouvrir la pull/merge request directement sur platform-gitops
	@echo "Deprecated : ajoute argocd/apps/<app>.yaml sur une branche et ouvre la pull/merge request directement sur platform-gitops." >&2
	@exit 1

get-gitlab-token: ## Affiche le GITLAB_TOKEN (usage : eval $(make get-gitlab-token))
	GITLAB_URL=https://gitlab.$(GITLAB_DOMAIN) \
	    GITLAB_NAMESPACE=$(GITLAB_NAMESPACE) python3 scripts/get-gitlab-token.py

argocd-repo-creds: ## Cree les credentials ArgoCD pour les repos manifests prives
	PLATFORM_REPO_ROOT=$(PLATFORM_REPO_ROOT) PLATFORM_REPO_URL=$(PLATFORM_REPO_URL) GITLAB_URL=https://gitlab.$(GITLAB_DOMAIN) \
	    GITLAB_NAMESPACE=$(GITLAB_NAMESPACE) ARGOCD_NAMESPACE=$(ARGOCD_NAMESPACE) \
	    GITLAB_TOKEN=$(GITLAB_TOKEN) python3 scripts/argocd-repo-creds.py

check-app-gitlab-ci: ## Verifie que <app>/.gitlab-ci.yml est coherent avec l'inventaire : make check-app-gitlab-ci APP=helloworld GITLAB_CI_FILE=../helloworld/.gitlab-ci.yml
	@test -n "$(APP)" || (echo "APP est requis" >&2; exit 1)
	@test -n "$(GITLAB_CI_FILE)" || (echo "GITLAB_CI_FILE est requis" >&2; exit 1)
	PLATFORM_REPO_ROOT=$(PLATFORM_REPO_ROOT) PLATFORM_REPO_URL=$(PLATFORM_REPO_URL) \
	    python3 scripts/check-app-gitlab-ci.py "$(APP)" --gitlab-ci-file "$(GITLAB_CI_FILE)"
