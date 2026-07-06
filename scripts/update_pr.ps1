param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$Message,

  [string]$Repo = "RippleOrApple/SimpleNote",
  [string]$Base = "main",
  [string]$Branch = "",
  [string]$Title = "",
  [string]$Body = "",
  [string]$BodyFile = "",
  [switch]$Ready
)

$ErrorActionPreference = "Stop"

function Invoke-Git {
  param([string[]]$GitArgs)
  & git @GitArgs
  if ($LASTEXITCODE -ne 0) {
    throw "git $($GitArgs -join ' ') failed"
  }
}

function Get-GitHubHeaders {
  $credential = "protocol=https`nhost=github.com`n`n" | git credential fill
  $token = ($credential -split "`n" | Where-Object { $_ -like "password=*" }) -replace "^password=", ""
  if (-not $token) {
    throw "GitHub token was not available from git credentials."
  }

  return @{
    Authorization          = "Bearer $token"
    Accept                 = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
    "User-Agent"           = "SimpleNote update_pr.ps1"
  }
}

function Push-HeadWithGitHubApi {
  param(
    [string]$Repo,
    [string]$Branch,
    [hashtable]$Headers
  )

  $remoteRef = Invoke-RestMethod `
    -Method Get `
    -Uri "https://api.github.com/repos/$Repo/git/ref/heads/$Branch" `
    -Headers $Headers
  $remoteSha = $remoteRef.object.sha
  $changes = git diff-tree --no-commit-id --name-status -r HEAD
  if ($LASTEXITCODE -ne 0) {
    throw "Unable to read HEAD changes."
  }

  $tree = @()
  foreach ($line in $changes) {
    if (-not $line.Trim()) {
      continue
    }

    $parts = $line -split "`t"
    $status = $parts[0]
    $path = $parts[-1]

    if ($status -like "D*") {
      $tree += @{ path = $path; mode = "100644"; type = "blob"; sha = $null }
      continue
    }

    $fullPath = Join-Path (Get-Location) $path
    $content = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($fullPath))
    $blobBody = @{ content = $content; encoding = "base64" } | ConvertTo-Json -Depth 5
    $blob = Invoke-RestMethod `
      -Method Post `
      -Uri "https://api.github.com/repos/$Repo/git/blobs" `
      -Headers $Headers `
      -Body $blobBody `
      -ContentType "application/json"
    $tree += @{ path = $path; mode = "100644"; type = "blob"; sha = $blob.sha }
  }

  $treeBody = @{ base_tree = $remoteSha; tree = $tree } | ConvertTo-Json -Depth 8
  $newTree = Invoke-RestMethod `
    -Method Post `
    -Uri "https://api.github.com/repos/$Repo/git/trees" `
    -Headers $Headers `
    -Body $treeBody `
    -ContentType "application/json"

  $commitBody = @{
    message   = (git log -1 --format="%B" | Out-String).TrimEnd()
    tree      = $newTree.sha
    parents   = @($remoteSha)
    author    = @{
      name  = (git log -1 --format="%an").Trim()
      email = (git log -1 --format="%ae").Trim()
      date  = (git log -1 --format="%aI").Trim()
    }
    committer = @{
      name  = (git log -1 --format="%cn").Trim()
      email = (git log -1 --format="%ce").Trim()
      date  = (git log -1 --format="%cI").Trim()
    }
  } | ConvertTo-Json -Depth 8
  $newCommit = Invoke-RestMethod `
    -Method Post `
    -Uri "https://api.github.com/repos/$Repo/git/commits" `
    -Headers $Headers `
    -Body $commitBody `
    -ContentType "application/json"

  $updateBody = @{ sha = $newCommit.sha; force = $false } | ConvertTo-Json
  $updatedRef = Invoke-RestMethod `
    -Method Patch `
    -Uri "https://api.github.com/repos/$Repo/git/refs/heads/$Branch" `
    -Headers $Headers `
    -Body $updateBody `
    -ContentType "application/json"

  return $updatedRef.object.sha
}

function Upsert-PullRequest {
  param(
    [string]$Repo,
    [string]$Branch,
    [string]$Base,
    [string]$Title,
    [string]$Body,
    [bool]$Draft,
    [hashtable]$Headers
  )

  $pulls = Invoke-RestMethod `
    -Method Get `
    -Uri "https://api.github.com/repos/$Repo/pulls?state=open&head=RippleOrApple:$Branch&base=$Base&per_page=10" `
    -Headers $Headers

  if (@($pulls).Count -gt 0) {
    $pull = @($pulls)[0]
    $payload = @{ title = $Title; body = $Body } | ConvertTo-Json -Depth 5
    return Invoke-RestMethod `
      -Method Patch `
      -Uri "https://api.github.com/repos/$Repo/pulls/$($pull.number)" `
      -Headers $Headers `
      -Body $payload `
      -ContentType "application/json"
  }

  $payload = @{
    title = $Title
    head  = $Branch
    base  = $Base
    body  = $Body
    draft = $Draft
  } | ConvertTo-Json -Depth 5

  return Invoke-RestMethod `
    -Method Post `
    -Uri "https://api.github.com/repos/$Repo/pulls" `
    -Headers $Headers `
    -Body $payload `
    -ContentType "application/json"
}

if (-not $Branch) {
  $Branch = (git branch --show-current).Trim()
}
if (-not $Branch) {
  throw "Could not determine the current branch."
}
if (-not $Title) {
  $Title = "[codex] $Message"
}

if (-not $Body) {
  $Body = "## Summary`n- $Message`n`n## Validation`n- Run local checks before publishing when the change needs verification.`n"
}
if ($BodyFile) {
  $Body = Get-Content -Raw $BodyFile
}

Invoke-Git @("add", "-A")
$staged = git diff --cached --name-only
if ($staged) {
  Invoke-Git @("commit", "-m", $Message)
} else {
  Write-Host "No staged changes; using existing HEAD."
}

$pushSucceeded = $false
git push origin $Branch
if ($LASTEXITCODE -eq 0) {
  $pushSucceeded = $true
} else {
  Write-Host "Normal git push was rejected. Updating the remote branch through the GitHub API."
  $headers = Get-GitHubHeaders
  $remoteSha = Push-HeadWithGitHubApi -Repo $Repo -Branch $Branch -Headers $headers
  Write-Host "Updated remote branch to $remoteSha."
}

if (-not $headers) {
  $headers = Get-GitHubHeaders
}
$pullRequest = Upsert-PullRequest `
  -Repo $Repo `
  -Branch $Branch `
  -Base $Base `
  -Title $Title `
  -Body $Body `
  -Draft:(-not $Ready.IsPresent) `
  -Headers $headers

[PSCustomObject]@{
  Branch        = $Branch
  LocalHead     = (git rev-parse HEAD).Trim()
  PushSucceeded = $pushSucceeded
  PullRequest   = $pullRequest.html_url
}
