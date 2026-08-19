param(
  [string]$Repo = "wpaksdl21-png/wpaksdl",
  [string]$Branch = "main",
  [string]$Domain = "",
  [string]$DomainUrl = ""
)

Set-Location -LiteralPath (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host "`n=== Microsoft 검증용 1페이지 자동 배포 스크립트 ===`n"

$repoOwnerRepo = Read-Host "GitHub repo (예: wpaksdl21-png/wpaksdl) [기본값: $Repo]"
if ([string]::IsNullOrWhiteSpace($repoOwnerRepo)) { $repoOwnerRepo = $Repo }

$branch = Read-Host "배포 브랜치 (예: main) [기본값: $Branch]"
if ([string]::IsNullOrWhiteSpace($branch)) { $branch = $Branch }

if ([string]::IsNullOrWhiteSpace($Domain)) {
  $Domain = Read-Host "도메인 (예: example.com, www 생략 가능)"
}

$DomainUrlInput = Read-Host "페이지에 노출할 공식 사이트 URL (예: https://example.com) [기본값: https://$Domain]"
if (-not [string]::IsNullOrWhiteSpace($DomainUrlInput)) {
  $DomainUrl = $DomainUrlInput
} elseif (-not [string]::IsNullOrWhiteSpace($Domain)) {
  $DomainUrl = "https://$Domain"
}

$companyName = Read-Host "회사명 (사업자등록증 상호명)"
$bizNo = Read-Host "사업자등록번호"
$ceo = Read-Host "대표자명"
$address = Read-Host "주소 (도로명+우편번호)"
$email = Read-Host "사업자 이메일 (예: contact@domain.com)"
$phone = Read-Host "연락처 (예: +82-10-xxxx-xxxx)"
$regDate = Read-Host "최종수정일(선택) [기본값: 2026-08-20]"
if ([string]::IsNullOrWhiteSpace($regDate)) { $regDate = "2026-08-20" }

$indexPath = Join-Path (Get-Location) "index.html"
$indexContent = Get-Content -Raw $indexPath
$indexContent = $indexContent -replace [regex]::Escape("[Your Company Name]"), [regex]::EscapeReplacement($companyName)
$indexContent = $indexContent -replace [regex]::Escape("[Your exact registered company name]"), [regex]::EscapeReplacement($companyName)
$indexContent = $indexContent -replace [regex]::Escape("[Business registration number]"), [regex]::EscapeReplacement($bizNo)
$indexContent = $indexContent -replace [regex]::Escape("[CEO / representative name]"), [regex]::EscapeReplacement($ceo)
$indexContent = $indexContent -replace [regex]::Escape("[Full business address: street, city, postal code]"), [regex]::EscapeReplacement($address)
$indexContent = $indexContent -replace [regex]::Escape("contact@yourdomain.com"), [regex]::EscapeReplacement($email)
$indexContent = $indexContent -replace [regex]::Escape("https://yourdomain.com"), [regex]::EscapeReplacement($DomainUrl)
$indexContent = $indexContent -replace '2026-08-20', $regDate
Set-Content -Path $indexPath -Value $indexContent -Encoding UTF8

if (-not [string]::IsNullOrWhiteSpace($Domain)) {
  $cnamePath = Join-Path (Get-Location) "CNAME"
  Set-Content -Path $cnamePath -Value $Domain -Encoding UTF8
}

if (-not (Test-Path "$((Get-Location).Path)\.git")) {
  git init | Out-Host
}

git add .
git add -A
git status --short

$message = "chore: set Microsoft verification page"
git commit -m $message

$remoteUrl = "https://github.com/$repoOwnerRepo.git"
git remote get-url origin *> $null
if ($LASTEXITCODE -ne 0) {
  git remote add origin $remoteUrl
} else {
  Write-Host "`n기존 origin이 이미 등록되어 있습니다."
}

git branch -M $branch
git push -u origin $branch

Write-Host "`n=== 완료 ==="
Write-Host "1) Git push done: $repoOwnerRepo ($branch)"
Write-Host "2) 남은 작업: GitHub Pages 설정 UI에서 다음만 수동 수행"
Write-Host "   - https://github.com/$repoOwnerRepo/settings/pages"
Write-Host "   - Source: Deploy from a branch / Branch: $branch / Folder: / (root)"
if (-not [string]::IsNullOrWhiteSpace($Domain)) {
  Write-Host "   - Custom domain: $Domain"
}
Write-Host "   - Enforce HTTPS ON"
