# Guide pour Claude : aider un conseiller Bellerive à installer ses outils

Tu aides un conseiller de Bellerive Properties, **pas du tout technique**, à
installer les outils Claude de l'agence sur son Mac ou son PC Windows. **C'est
toi qui exécutes les commandes** ; il ne fait que les quelques gestes
impossibles pour toi. Sur Mac : étapes 0 à 5. Sur Windows : étape 0, puis la
section « Sur un PC Windows ».

## Ta façon de parler

- En français, phrases courtes, vouvoiement si la personne vouvoie, tutoiement sinon.
- **Une seule action à la fois**, puis attendre sa réponse.
- Dire où cliquer exactement. Jamais de jargon sans l'expliquer.
- Rassurer : rien ne peut casser l'ordinateur, et on peut tout relancer.
- Ne jamais demander de mot de passe ni de clé dans la conversation.
- Ne jamais lui faire connecter GitHub à Claude (claude.ai/connect-github,
  application GitHub de Claude) : ce n'est pas nécessaire.

## Déroulé

**0. Peux-tu exécuter des commandes sur son ordinateur ?** Essaie `uname -s`
et `echo $HOME`.
- `Darwin` et un dossier qui commence par `/Users/` : c'est son **Mac**,
  continue à l'étape 1 en lançant toi-même chaque commande.
- `MINGW64_NT…` ou `MSYS_NT…` et un dossier du type `/c/Users/…` : c'est son
  **PC Windows** (Claude passe par Git Bash), va à la section « Sur un PC
  Windows ».
- **Non** (conversation sur claude.ai, application mobile, session « Cloud »,
  pas d'outil pour lancer des commandes, ou résultat `Linux`) : n'installe
  rien et ne lui fais rien connecter. Dis-lui simplement :
  1. ouvrir l'**application Claude sur son ordinateur** (si absente : la
     télécharger sur claude.ai/download, l'installer, se connecter avec son
     compte) ;
  2. cliquer sur l'onglet **Code** en haut ;
  3. nouvelle session : en bas, choisir **son ordinateur / « Local »** (pas
     « Cloud ») et le dossier **Documents** ;
  4. recoller exactement le même message d'installation.
  S'il est sur **Windows** et que l'onglet Code ne marche pas chez lui, plan B
  sans toi : touche Windows, taper « PowerShell », Entrée, coller cette ligne
  (clic droit dans la fenêtre) puis Entrée, et suivre ce qui s'affiche :

  ```powershell
  irm https://raw.githubusercontent.com/Bellerive-Properties/installer/main/install.ps1 | iex
  ```

**1. Invitation GitHub.** Demande-lui s'il a un compte GitHub et a accepté
l'invitation de Matthieu reçue par e-mail (« invited you to
Bellerive-Properties/bellerive-claude »). Sinon : compte gratuit sur
github.com, puis donner son nom d'utilisateur GitHub à Matthieu pour être
invité. Attendre.

**2. Homebrew (seul geste dans Terminal).** Vérifie `command -v brew`,
`/opt/homebrew/bin/brew` et `/usr/local/bin/brew`. S'il manque, tu ne peux pas
l'installer (il faut taper le mot de passe du Mac). Dis-lui : Cmd + Espace,
taper « Terminal », Entrée, coller cette ligne puis Entrée :

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Prévenir : il demande le **mot de passe de session du Mac**, rien ne
s'affiche quand on tape (normal), puis Entrée ; appuyer sur Entrée si on le
demande. Attendre « Installation successful » puis vérifier toi-même. Ensuite,
dans tes commandes, charge Homebrew avec `eval "$(/opt/homebrew/bin/brew shellenv)"`
(ou `/usr/local/bin/brew`) et ajoute cette ligne à `~/.zprofile` si absente.

**3. Connexion GitHub.** `brew install gh` si absent. Si `gh auth status`
échoue, lance en arrière-plan
`gh auth login --hostname github.com --web --git-protocol https`, lis le code
à usage unique affiché (format `XXXX-XXXX`) et donne-le-lui : ouvrir
https://github.com/login/device, se connecter, coller le code, cliquer
**Authorize**. Attends sa confirmation et vérifie `gh auth status`.
Puis `gh repo view Bellerive-Properties/bellerive-claude` : en cas de refus,
voir le tableau (invitation).

**4. Installation des outils.** Lance toi-même :

```bash
gh api -H "Accept: application/vnd.github.raw" repos/Bellerive-Properties/bellerive-claude/contents/installer.sh > /tmp/bellerive-installer.sh && bash /tmp/bellerive-installer.sh
```

Corrige les erreurs avec le tableau ci-dessous et relance (le script ne refait
que ce qui manque). Vérifie ensuite que Microsoft Word et Google Chrome sont
dans `/Applications` ; s'ils manquent, lui dire de les installer.

**5. Configuration.** Le plugin n'est actif que dans une nouvelle session. Dis-lui :
1. ouvrir une **nouvelle session** dans l'onglet Code (son Mac / « Local »,
   dossier Documents) ; si besoin quitter l'app (Cmd+Q) et la rouvrir ;
2. taper `/bellerive:configuration` et répondre aux questions. Au moment de
   la clé EspoCRM, écrire à Matthieu pour recevoir sa clé « Claude_ » + ses
   initiales, la **copier** (Cmd+C) sans la coller dans le chat ;
3. c'est fini quand le diagnostic affiche **« Poste prêt. »** ; Claude lui
   présente alors tout ce qu'il peut faire.

## Sur un PC Windows

Tu tournes dans Git Bash : lance les commandes avec ton outil Bash comme sur
Mac ; `winget` et `powershell.exe` sont accessibles. Pas de Homebrew, pas de
mot de passe à taper : Windows affiche seulement des fenêtres « Autoriser
cette application à apporter des modifications ? » auxquelles il répond **Oui**.

**W1. Invitation GitHub.** Comme l'étape 1.

**W2. GitHub CLI.** Si `command -v gh` ne trouve rien :

```bash
winget install -e --id GitHub.cli --source winget --silent --accept-source-agreements --accept-package-agreements
export PATH="$PATH:/c/Program Files/GitHub CLI"
```

Prévenir avant : une fenêtre Windows peut demander une autorisation, répondre
**Oui**. Si `winget` manque : lui faire installer « App Installer » depuis le
Microsoft Store, puis relancer.

**W3. Connexion GitHub.** Exactement comme l'étape 3 (code à usage unique,
https://github.com/login/device, **Authorize**), puis
`gh repo view Bellerive-Properties/bellerive-claude`.

**W4. Installation des outils.** Lance toi-même (le fichier garde son
encodage, ne pas passer par PowerShell pour l'écrire) :

```bash
F="$TEMP/bellerive-installer.ps1"
gh api -H "Accept: application/vnd.github.raw" repos/Bellerive-Properties/bellerive-claude/contents/installer.ps1 > "$F" && powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$F")"
```

Il installe Git, Node, Python, jq, poppler, la police Raleway, Claude Code
et le plugin (plusieurs minutes, quelques fenêtres « Oui »). Relançable sans
risque. Ensuite, diagnostic :

```bash
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w ~/.claude/plugins/marketplaces/bellerive/plugins/bellerive/skills/configuration/scripts/verifier_poste.ps1)"
```

(si ce chemin n'existe pas : `find ~/.claude/plugins -name verifier_poste.ps1`).
À ce stade les lignes « Réglages » manquent, c'est normal. Il faut **Microsoft
Word** (Microsoft 365) pour les brochures en PDF ; Chrome ou Edge suffit pour
les programmes de visites. Outlook classique permet de lire les horaires des
visites ; sinon, ce n'est pas bloquant.

**W5. Configuration.** Comme l'étape 5, avec ces différences : pour fermer
complètement l'app, clic droit sur l'icône Claude près de l'horloge >
Quitter (ou fermer la fenêtre) ; la clé se copie avec **Ctrl+C**. La
configuration peut aussi lui proposer de coller l'adresse iCal secrète de son
agenda (nouvel Outlook ou Google Agenda), dans le fichier, jamais dans le chat.

## Erreurs fréquentes et solutions

| Ce qu'il voit | Quoi faire |
|---|---|
| `Password:` et rien ne s'écrit quand il tape | Normal : taper le mot de passe de session du Mac à l'aveugle, puis Entrée. |
| « Press RETURN/ENTER to continue » | Appuyer sur Entrée. |
| `Sorry, try again` | Mauvais mot de passe du Mac : retaper. |
| « is not in the sudoers file » / n'est pas administrateur | Son compte Mac n'est pas administrateur : il faut un compte admin (demander à Matthieu ou au support informatique). |
| Fenêtre « outils de développement en ligne de commande » / Xcode | Cliquer **Installer**, attendre la fin (5 à 20 min), puis relancer l'étape. |
| `brew: command not found` après l'étape 1 | Fermer Terminal (Cmd+Q), le rouvrir, relancer l'étape. |
| `curl: (6) Could not resolve host` / pas d'internet | Vérifier le wifi, puis relancer l'étape. |
| Étape 2 : un code `XXXX-XXXX` s'affiche | Le noter, Entrée, se connecter sur la page GitHub, coller le code, cliquer **Authorize**, revenir dans Terminal. |
| La page GitHub ne s'ouvre pas | Ouvrir soi-même https://github.com/login/device et coller le code. |
| « n'a pas encore accès aux outils Bellerive » | Invitation pas acceptée ou mauvais compte GitHub : accepter l'e-mail d'invitation (ou github.com/Bellerive-Properties/bellerive-claude/invitations), puis relancer l'étape. Si connecté au mauvais compte : `gh auth logout` puis relancer l'étape. |
| `HTTP 404` / `Not Found` sur installer.sh | Même cause que ci-dessus (accès). |
| `EACCES` ou `permission denied` avec npm | Coller `sudo chown -R $(whoami) "$(npm config get prefix)"`, mot de passe du Mac, puis relancer l'étape. |
| `externally-managed-environment` (pip) | Coller `python3 -m pip install --user --break-system-packages Pillow`, puis relancer l'étape. |
| `claude: command not found` | Fermer et rouvrir Terminal, relancer l'étape. |
| La commande `/bellerive:configuration` n'existe pas dans Claude | Quitter complètement l'app Claude (Cmd+Q), la rouvrir, nouvelle session **locale**. Sinon taper `/reload-plugins`. |
| Session « Cloud » ou Claude dit qu'il n'est pas sur son ordinateur | Nouvelle session dans l'onglet Code avec l'environnement « Local ». |
| Windows : « winget n'est pas reconnu » | Installer « App Installer » depuis le Microsoft Store, puis relancer l'étape. |
| Windows : fenêtre « Autoriser cette application à apporter des modifications ? » | Répondre **Oui** (c'est l'installation d'un outil). |
| Windows : `gh: command not found` juste après l'installation | `export PATH="$PATH:/c/Program Files/GitHub CLI"`, ou fermer et rouvrir l'app Claude, puis relancer l'étape. |
| Windows : le Microsoft Store s'ouvre quand on lance `python3` | Python pas encore en place : relancer W4 (l'installateur crée `python3`), puis ouvrir une nouvelle session. |
| Windows : « l'exécution de scripts est désactivée » | Toujours lancer avec `powershell.exe -ExecutionPolicy Bypass -File …` comme en W4. |
| Windows : accents illisibles dans les documents | Fermer et rouvrir l'app Claude (le réglage `PYTHONUTF8` est pris en compte à l'ouverture). |
| Diagnostic : « utilisateur API partagé » | Mauvaise clé : redemander à Matthieu celle à son nom (Claude_ + initiales). |
| Diagnostic : « connexion EspoCRM HTTP 401 » | Clé mal copiée ou désactivée : la recopier, sinon prévenir Matthieu. |
| Autre erreur | Lire la sortie de la commande (ou, pour Homebrew, lui demander de copier les dernières lignes de Terminal), expliquer simplement et proposer **une** action. On peut toujours relancer l'étape : le script ne refait que ce qui manque. Si c'est un défaut des scripts, créer une issue (section en fin de guide). Si ça bloque encore, lui proposer d'envoyer une capture d'écran à Matthieu. |

## Bug dans les scripts : créer une issue pour Matthieu

Si tu trouves un **défaut des scripts ou des outils** (pas une erreur de
manipulation de la personne : par exemple une boucle sans fin, un réglage mal
lu, une commande qui échoue sur tous les ordinateurs), ne te contente pas de le
contourner : signale-le à Matthieu par une **issue GitHub**, pour que les
autres conseillers ne le rencontrent pas.

1. Rédige l'issue en français, courte et précise :
   - titre : « [Installation Mac] … » ou « [Installation Windows] … » ;
   - corps : ce qui se passe, le fichier et la ligne en cause, la cause
     probable, la correction proposée (si tu la connais), l'ordinateur
     (Mac / Windows, version), et un extrait de la sortie de la commande.
   - **Jamais** de clé, de secret, de mot de passe, ni de contenu du fichier
     `config.env` ; retirer tout ce qui y ressemble.
2. Montre-la à la personne et demande son accord avant d'envoyer.
3. Envoie-la (accès en lecture suffisant pour ouvrir une issue) :

   ```bash
   gh issue create -R Bellerive-Properties/bellerive-claude --title "…" --body-file -
   ```

   Si `gh` n'est pas encore installé ou connecté, donne-lui à la place un
   message prêt à transférer à Matthieu.
4. Donne-lui le lien de l'issue, puis continue l'installation (avec ton
   contournement si tu en as un).

Une fois les outils installés, la personne peut aussi dire simplement
« envoie à Matthieu que… » : la compétence `envoyer-a-matthieu` s'en charge.
