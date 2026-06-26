# poc-devops-toolbox

Scripts partagés pour piloter les projets `poc-devops`.

Les scripts de bootstrap restent utilisables depuis `poc-devops-platform`. Cette toolbox contient une copie réutilisable des utilitaires Python, avec une racine plateforme configurable.

## Installation

```sh
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

## Utilisation depuis `poc-devops-platform`

Depuis le dépôt plateforme:

```sh
PLATFORM_REPO_ROOT="$PWD" python3 ../poc-devops-toolbox/scripts/render-argocd-apps.py > argocd/managed/apps-appset.yaml
PLATFORM_REPO_ROOT="$PWD" python3 ../poc-devops-toolbox/scripts/init-project.py ../helloworld ../helloworld-iac
PLATFORM_REPO_ROOT="$PWD" python3 ../poc-devops-toolbox/scripts/gitlab-seed.py
PLATFORM_REPO_ROOT="$PWD" python3 ../poc-devops-toolbox/scripts/argocd-repo-creds.py
python3 ../poc-devops-toolbox/scripts/gitlab-runner-token.py
```

Depuis n'importe quel autre répertoire, renseigner `PLATFORM_REPO_ROOT` avec le chemin absolu du dépôt `poc-devops-platform`.

## Scripts

- `filter-argocd-install.py`: filtre le manifeste d'installation ArgoCD.
- `render-argocd-apps.py`: génère les `AppProject` et l'`ApplicationSet` depuis l'inventaire apps.
- `init-project.py` et `init_projects/`: ajoute ou met à jour une app dans `argocd/apps/*.yaml`.
- `gitlab-seed.py`: crée et alimente les projets GitLab déclarés dans l'inventaire.
- `gitlab-runner-token.py`: crée le token runner GitLab et le Secret Kubernetes associé.
- `argocd-repo-creds.py`: crée les credentials ArgoCD pour les dépôts manifests privés.

## Variables utiles

- `PLATFORM_REPO_ROOT`: racine du dépôt plateforme. Par défaut: répertoire courant.
- `APPS_FILE`: chemin explicite vers l'inventaire apps.
- `APPS_DIR`: dossier contenant les fichiers app YAML.
- `GITLAB_NAMESPACE`, `GITLAB_URL`, `ARGOCD_NAMESPACE`: paramètres Kubernetes/GitLab utilisés par les scripts de bootstrap.
