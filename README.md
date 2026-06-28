# toolbox

Scripts partagés pour piloter les projets `poc-devops`.

Les scripts de bootstrap restent utilisables depuis `platform-cicd`. Cette
toolbox contient une copie réutilisable des utilitaires Python, avec une racine
GitOps configurable. Par defaut, cette racine est `../platform-gitops`.

## Installation

```sh
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

## Ajouter un projet sans checkout GitOps

Pour ajouter un projet standard comme `helloworld`, le developpeur n'a pas
besoin de cloner `platform-gitops`. Depuis le dossier qui contient les
dépôts `helloworld` et `helloworld-iac`:

```sh
PLATFORM_REPO_URL=https://github.com/poc-devops-elkouhen/platform-gitops.git \
GITHUB_TOKEN=<token> \
python3 /chemin/toolbox/scripts/init-project.py helloworld
```

Le script clone temporairement le dépôt GitOps, ajoute ou met à jour
`argocd/apps/helloworld.yaml`, régénère `argocd/managed/apps-appset.yaml`, pousse
une branche `toolbox/add-helloworld`, puis ouvre une pull request.

Si les dépôts applicatifs sont dans un autre dossier:

```sh
PLATFORM_REPO_URL=https://github.com/poc-devops-elkouhen/platform-gitops.git \
GITHUB_TOKEN=<token> \
PROJECTS_DIR=/chemin/projets \
python3 /chemin/toolbox/scripts/init-project.py helloworld
```

Les URLs Git restent possibles lorsque le développeur n'a pas non plus les
dépôts applicatifs en local:

```sh
PLATFORM_REPO_URL=https://github.com/poc-devops-elkouhen/platform-gitops.git \
GITHUB_TOKEN=<token> \
python3 /chemin/toolbox/scripts/init-project.py \
  https://git.example.com/team/helloworld.git \
  https://git.example.com/team/helloworld-iac.git
```

## Supprimer un projet sans checkout GitOps

Pour retirer `helloworld` de la plateforme sans cloner `platform-gitops`:

```sh
PLATFORM_REPO_URL=https://github.com/poc-devops-elkouhen/platform-gitops.git \
GITHUB_TOKEN=<token> \
python3 /chemin/toolbox/scripts/delete-project.py helloworld
```

Le script supprime l'entrée `argocd/apps/helloworld.yaml` du dépôt GitOps,
régénère `argocd/managed/apps-appset.yaml`, pousse une branche
`toolbox/delete-helloworld`, puis ouvre une pull request. Il ne supprime pas les
dépôts GitLab applicatifs.

## Utilisation avec checkout GitOps

Depuis le dépôt GitOps, pour les opérations d'administration:

```sh
PLATFORM_REPO_ROOT="$PWD" python3 ../toolbox/scripts/render-argocd-apps.py > argocd/managed/apps-appset.yaml
PLATFORM_REPO_ROOT="$PWD" python3 ../toolbox/scripts/init-project.py helloworld
PLATFORM_REPO_ROOT="$PWD" python3 ../toolbox/scripts/init-project.py ../helloworld ../helloworld-iac
PLATFORM_REPO_ROOT="$PWD" python3 ../toolbox/scripts/delete-project.py helloworld
PLATFORM_REPO_ROOT="$PWD" python3 ../toolbox/scripts/gitlab-seed.py
PLATFORM_REPO_ROOT="$PWD" python3 ../toolbox/scripts/argocd-repo-creds.py
python3 ../toolbox/scripts/gitlab-runner-token.py
```

Depuis n'importe quel autre répertoire, renseigner `PLATFORM_REPO_ROOT` avec le chemin absolu du dépôt `platform-gitops`.

## Scripts

- `filter-argocd-install.py`: filtre le manifeste d'installation ArgoCD.
- `render-argocd-apps.py`: génère les `AppProject` et l'`ApplicationSet` depuis l'inventaire apps.
- `init-project.py` et `init_projects/`: ajoute ou met à jour une app dans `argocd/apps/*.yaml`.
- `delete-project.py`: supprime une app de `argocd/apps/*.yaml` et ouvre une pull/merge request en mode `PLATFORM_REPO_URL`.
- `gitlab-seed.py`: crée et alimente les projets GitLab déclarés dans l'inventaire.
- `gitlab-runner-token.py`: crée le token runner GitLab et le Secret Kubernetes associé.
- `argocd-repo-creds.py`: crée les credentials ArgoCD pour les dépôts manifests privés.

## Variables utiles

- `PLATFORM_REPO_ROOT`: racine du dépôt GitOps. Par defaut: `../platform-gitops`.
- `PLATFORM_REPO_URL`: URL GitHub du dépôt GitOps source. Si renseignée, les scripts projet ouvrent une pull request au lieu d'écrire dans un checkout local.
- `GITHUB_TOKEN`: token utilisé pour cloner/pousser le dépôt GitOps GitHub et créer la pull request.
- `GITLAB_TOKEN`: token utilisé pour les opérations contre le GitLab de la plateforme (`gitlab-seed`, credentials ArgoCD).
- `PROJECTS_DIR`: dossier contenant les dépôts applicatifs lorsque `init-project.py` est appelé avec un nom de projet. Par défaut: répertoire courant en mode `PLATFORM_REPO_URL`, sinon dossier parent du dépôt GitOps.
- `APPS_FILE`: chemin explicite vers l'inventaire apps.
- `APPS_DIR`: dossier contenant les fichiers app YAML.
- `GITLAB_NAMESPACE`, `GITLAB_URL`, `ARGOCD_NAMESPACE`: paramètres Kubernetes/GitLab utilisés par les scripts de bootstrap.
