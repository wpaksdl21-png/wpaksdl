# 원클릭 자동화(네트워크/인증 가능 환경 기준)

프로젝트 루트에서 PowerShell로 아래를 실행하면 됩니다.

```powershell
.\auto-deploy.ps1
```

스크립트가 묻는 값:
- repo (기본값: wpaksdl21-png/wpaksdl)
- branch (기본값: main)
- 도메인, 사업자 정보(회사명/사업자번호/대표자/주소/이메일/전화)

완료 시 스크립트는 마지막에 다음만 수동으로 남깁니다.
- GitHub Pages에서 Source: Deploy from a branch / Branch: main / / (root)
- Custom domain: 입력한 도메인
- HTTPS ON

# GitHub Pages + 도메인 연결(최소 1페이지 검증용)

이 폴더의 `index.html`만 있으면 Microsoft 검증용 페이지로 사용 가능합니다.  
아래 순서대로만 하면 됩니다.

## 1) GitHub 저장소로 이동
- 새 저장소 생성 또는 기존 저장소 사용
- 이 폴더를 저장소에 업로드(또는 Git으로 초기화 후 푸시)

## 2) Pages 설정
- Settings → Pages
- Source: `Deploy from a branch`
- Branch: `main` (폴더: `/ (root)`)
- Save

## 3) 커스텀 도메인 연결
- `CNAME` 파일의 `yourdomain.com`을 실제 도메인으로 수정
- Settings → Pages → Custom domain 에 실제 도메인 입력
- Enforce HTTPS 체크

## 4) DNS 설정(도메인 등록사)
- `CNAME`(권장):  
  - `www` → `username.github.io`
- `A` 레코드 사용 시: GitHub Pages 공식 IP 4개를 등록하고 루트 도메인 연결

## 5) 유지 확인
- `https://yourdomain.com` 접속 가능한지 확인
- Microsoft 가입 화면에 같은 도메인/이메일/사업자 정보가 일치하는지 재확인
- 페이지에서 실제 주소/회사명/연락처가 공개되어 있는지 확인

## 6) index 내용 수정(필수 3개)
- `[Your Company Name]`
- `[Your exact registered company name]`
- `[Business registration number]`
- `[Full business address: street, city, postal code]`
- `contact@yourdomain.com`
- `https://yourdomain.com`
- `+82-[country code + phone number]`
