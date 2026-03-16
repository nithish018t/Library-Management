# One Piece Project Layout

## GitHub Pages frontend

These files and folders are the website UI and should stay in the repository root for GitHub Pages:

- `index.html`
- `dashboard.html`
- `announcements.html`
- `borrowed.html`
- `fines-dues.html`
- `magazines.html`
- `profile.html`
- `reading-history.html`
- `textbooks.html`
- `app-config.js`
- `style.css`
- `script.js`
- `background.jpg`
- `data-analyst.png`
- `Books/`
- `Magazines/`
- `Profile Pictures/`

## Render backend

These files belong to the Spring Boot API and should be deployed from `backend/` on Render:

- `backend/pom.xml`
- `backend/src/main/java/`
- `backend/src/main/resources/`

## Local-only or support files

These are not part of the GitHub Pages site:

- `mysql_setup.sql`
- `books_import.csv`
- `books_with_authors.csv`
- `cse_subject_reference_sites.xlsx`
- `cse_subject_reference_sites.zip`
- `_xlsx_tmp/`
- `.m2/`
- `.vscode/`
- `tools/`

## What was changed for GitHub Pages + Render

- Frontend pages now read the API URL from `app-config.js`.
- Local development still uses `http://localhost:8080/api/auth`.
- Production uses the Render backend URL from `app-config.js`.
- Backend now reads `PORT`, `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, and `SPRING_DATASOURCE_PASSWORD` from environment variables.

## Before you deploy

1. Create the Render backend service from `backend/`.
2. Replace the placeholder URL in `app-config.js` with your actual Render URL.
3. Push the repo to GitHub.
4. Enable GitHub Pages from the repo root.
