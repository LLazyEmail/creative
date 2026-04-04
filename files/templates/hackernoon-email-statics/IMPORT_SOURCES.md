# Import Sources — hackernoon-email-statics

## Overview

This directory mirrors static assets from the HackerNoon creative GitLab repository
into `files/templates/hackernoon-email-statics/` for local use in email templates and
newsletters.

---

## Import Date

**2026-04-04**

---

## Source Repository

| Field    | Value                                         |
|----------|-----------------------------------------------|
| Platform | GitLab                                        |
| Project  | `hackernoon/creative`                         |
| URL      | https://gitlab.com/hackernoon/creative        |
| Branch   | `master`                                      |

---

## Source Folders & File Counts

| Source Folder (GitLab)                                   | Local Destination                            | Files |
|----------------------------------------------------------|----------------------------------------------|-------|
| `newsletters/logos/brand`                                | `newsletters/logos/brand/`                   | 1     |
| `newsletters/logos/all`                                  | `newsletters/logos/all/`                     | 31     |
| `newsletters/logos/thematic/2021`                        | `newsletters/logos/thematic/2021/`           | 1     |
| `newsletters/memes/2021/Jan`                             | `newsletters/memes/2021/Jan/`                | 1     |


---

## Source URLs

```
https://gitlab.com/hackernoon/creative/-/tree/master/newsletters/logos/brand
https://gitlab.com/hackernoon/creative/-/tree/master/newsletters/logos/all
https://gitlab.com/hackernoon/creative/-/tree/master/newsletters/logos/thematic/2021
https://gitlab.com/hackernoon/creative/-/tree/master/newsletters/memes/2021/Jan
```

---

## Directory Structure

```
files/templates/hackernoon-email-statics/
├── IMPORT_SOURCES.md             ← this file
├── fetch-from-gitlab.sh          ← download script (run locally with GitLab access)
└── newsletters/
    ├── logos/
    │   ├── brand/                ← brand logos (from newsletters/logos/brand)
    │   ├── all/                  ← all logo variants (from newsletters/logos/all)
    │   └── thematic/
    │       └── 2021/             ← 2021 thematic logos (from newsletters/logos/thematic/2021)
    └── memes/
        └── 2021/
            └── Jan/              ← January 2021 memes (from newsletters/memes/2021/Jan)
```

---

## How to Complete the Import

### Option A — Run locally

```bash
cd files/templates/hackernoon-email-statics
chmod +x fetch-from-gitlab.sh

# Optional: set a GitLab Personal Access Token to avoid rate limiting
export GITLAB_TOKEN="<your_token>"

./fetch-from-gitlab.sh
git add newsletters/
git commit -m "Import HackerNoon static assets from GitLab"
git push
```

### Option B — GitHub Actions

Trigger the `import-gitlab-assets` workflow from the **Actions** tab in this repository.
The workflow downloads all files from the four GitLab source folders and commits them to
this branch automatically.

---

## File Preservation Policy

- Original filenames and extensions are preserved exactly as they appear in GitLab.
- Binary image files (PNG, JPG, GIF, SVG, etc.) are downloaded unmodified.
- Sub-directory structure within each source folder is preserved.
