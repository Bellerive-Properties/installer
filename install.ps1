# Installation des outils Claude de Bellerive Properties (Windows).
# Lancement : dans PowerShell, coller la ligne donnée par Matthieu :
#   irm https://raw.githubusercontent.com/Bellerive-Properties/installer/main/install.ps1 | iex
# Ne contient aucune clé : le vrai installateur (installer.ps1) est dans le dépôt privé.
function Start-BelleriveInstall {
  [Console]::OutputEncoding = [Text.Encoding]::UTF8
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $REPO = 'Bellerive-Properties/bellerive-claude'
  function Titre($t) { Write-Host "`n== $t" -ForegroundColor Yellow }
  function Refresh-Path { $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User') }

  Write-Host 'Installation des outils Claude Bellerive (10 à 15 minutes).'
  Write-Host 'Laissez cette fenêtre ouverte jusqu''au message « Terminé ».'

  Titre 'Étape 1 sur 3 : connexion à GitHub'
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host 'Il manque « App Installer » : ouvrez le Microsoft Store, cherchez « App Installer », installez-le, puis recollez la même ligne.' -ForegroundColor Red
    return
  }
  if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host 'Si Windows demande « Autoriser cette application à apporter des modifications ? », répondez Oui.'
    winget install -e --id GitHub.cli --source winget --silent --accept-source-agreements --accept-package-agreements | Out-Null
    Refresh-Path
  }
  if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host 'GitHub CLI pas encore disponible : fermez PowerShell, rouvrez-le et recollez la même ligne.' -ForegroundColor Red
    return
  }
  gh auth status 2>$null | Out-Null
  if ($LASTEXITCODE -ne 0) {
    Write-Host '1. Un CODE va s''afficher ci-dessous (ex. ABCD-1234) : notez-le.'
    Write-Host '2. Appuyez sur Entrée : une page GitHub s''ouvre dans le navigateur.'
    Write-Host '3. Connectez-vous, collez le code, puis cliquez sur « Authorize ».'
    gh auth login --hostname github.com --web --git-protocol https
  }
  gh repo view $REPO --json name 2>$null | Out-Null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "`nVotre compte GitHub n'a pas encore accès aux outils Bellerive." -ForegroundColor Red
    Write-Host 'Acceptez l''invitation reçue par e-mail (ou demandez-la à Matthieu), puis recollez la même ligne.'
    return
  }
  Write-Host 'OK'

  Titre 'Étape 2 sur 3 : outils Bellerive'
  $b64 = (gh api "repos/$REPO/contents/installer.ps1" --jq .content) -join ''
  $s = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b64)).TrimStart([char]0xFEFF)
  & ([scriptblock]::Create($s))

  Titre 'Étape 3 sur 3 : à faire dans l''application Claude'
  Write-Host '  1. Ouvrez l''application Claude (claude.ai/download si absente), onglet « Code ».'
  Write-Host '  2. Nouvelle session sur ce PC (pas « Cloud »), dossier Documents.'
  Write-Host '  3. Tapez :   /bellerive:configuration'
  Write-Host 'Vous pouvez fermer cette fenêtre.'
}
Start-BelleriveInstall
