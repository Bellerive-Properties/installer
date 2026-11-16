#!/bin/bash
# Installation des outils Claude de Bellerive Properties (Mac).
# Lancement : coller dans l'app Terminal la ligne donnée par Matthieu.
# Ne contient aucune clé : le vrai installateur est dans le dépôt privé.
set -e
REPO="Bellerive-Properties/bellerive-claude"
titre() { printf '\n\033[1;33m== %s\033[0m\n' "$1"; }

echo "Installation des outils Claude Bellerive (10 à 15 minutes)."
echo "Laissez cette fenêtre ouverte jusqu'au message « TERMINÉ »."

titre "Étape 1 sur 4 : Homebrew"
if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
  echo "Le Mac va demander votre MOT DE PASSE DE SESSION (celui pour ouvrir le Mac)."
  echo "Quand vous le tapez, rien ne s'affiche : c'est normal. Tapez-le puis Entrée."
  echo "Si on vous demande d'appuyer sur Entrée (RETURN), faites-le."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$b" ]; then
    eval "$("$b" shellenv)"
    grep -qs "$b shellenv" ~/.zprofile || echo "eval \"\$($b shellenv)\"" >> ~/.zprofile
    break
  fi
done
echo "OK"

titre "Étape 2 sur 4 : connexion à GitHub"
command -v gh >/dev/null 2>&1 || brew install gh
if ! gh auth status >/dev/null 2>&1; then
  echo "1. Un CODE va s'afficher ci-dessous (ex. ABCD-1234) : notez-le."
  echo "2. Appuyez sur Entrée : une page GitHub s'ouvre dans le navigateur."
  echo "3. Connectez-vous, collez le code, puis cliquez sur « Authorize »."
  gh auth login --hostname github.com --web --git-protocol https
fi
if ! gh repo view "$REPO" >/dev/null 2>&1; then
  echo
  echo "Votre compte GitHub n'a pas encore accès aux outils Bellerive."
  echo "Acceptez l'invitation reçue par e-mail (ou demandez-la à Matthieu),"
  echo "puis relancez exactement la même ligne dans Terminal."
  exit 1
fi
echo "OK"

titre "Étape 3 sur 4 : outils Bellerive"
gh api -H "Accept: application/vnd.github.raw" "repos/$REPO/contents/installer.sh" > /tmp/bellerive-installer.sh
bash /tmp/bellerive-installer.sh

titre "Étape 4 sur 4 : à faire dans l'application Claude"
[ -d "/Applications/Microsoft Word.app" ] || echo "À installer aussi : Microsoft Word (pour les brochures en PDF)."
[ -d "/Applications/Google Chrome.app" ] || echo "À installer aussi : Google Chrome (pour les programmes de visites)."
[ -d "/Applications/Claude.app" ] || echo "À installer aussi : l'application Claude pour Mac (claude.ai/download)."
cat <<'FIN'

TERMINÉ.

Maintenant :
  1. Ouvrez l'application Claude, onglet « Code ».
  2. Nouvelle session (sur ce Mac, pas « Cloud »), dossier Documents.
  3. Tapez :   /bellerive:configuration
Claude vous pose quelques questions, vous dit quand demander votre clé
à Matthieu, puis vous montre tout ce que vous pouvez faire.

Vous pouvez fermer cette fenêtre.
FIN
