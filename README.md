# rate-your-professor

CSUB RATE YOUR PROFESSOR
DATABASE CLASS PROJECT

Some pages are written in PHP and some in Flask. Both connect to the same
MariaDB database (`csubryp`) on Artemis.

## Repo layout

| Folder | What goes there |
|---|---|
| `sql/` | `tables.sql` (schema), `data.sql` (mock data), `csubryp.sql` (loads both into `csubryp`) |
| `php/` | PHP pages. `includes/` for shared pieces like the connection and nav, `css/` for styles |
| `flask_app/` | Flask app. `templates/` for HTML, `static/` for CSS, JS and images |
| `docs/` | ER diagram and other write-ups |

## One-time setup (everyone)

### 1. SSH key for Artemis

Add this to `~/.ssh/config` on your computer, with your own Artemis username:

```
Host artemis
    HostName artemis.cs.csub.edu
    User YOUR_ARTEMIS_USERNAME

# Database tunnel only, for working on your own computer
Host artemis-tunnel
    HostName artemis.cs.csub.edu
    User YOUR_ARTEMIS_USERNAME
    LocalForward 3307 127.0.0.1:3306
    ExitOnForwardFailure yes
```

Then copy your public key to Artemis. It asks for your Artemis password one last time.

```sh
ls ~/.ssh/id_ed25519.pub || ssh-keygen -t ed25519   # make a key if you don't have one
ssh-copy-id artemis                                 # Mac / Linux
```

On Windows (PowerShell), instead of `ssh-copy-id`:

```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh artemis "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

After that, `ssh artemis` logs in without a password.

### 2. Your MariaDB password

Your own MariaDB account has access to `csubryp`. The password is in `~/.my.cnf`
on Artemis:

```sh
ssh artemis grep password .my.cnf
```

## PHP (on Artemis, no setup on your computer)

```sh
ssh artemis
git clone https://github.com/anglestrada/rate-your-professor.git ~/ryp
ln -s ~/ryp/php ~/public_html/ryp
cp ~/ryp/php/config.example.php ~/ryp/php/config.php
nano ~/ryp/php/config.php          # fill in your MariaDB username and password
```

Your pages are at `https://artemis.cs.csub.edu/~YOUR_ARTEMIS_USERNAME/ryp/`.
Get teammates' changes with `cd ~/ryp && git pull`.

The repo lives in `~/ryp`, and only the `php/` folder is linked into
`public_html`. That keeps `.git/` and `.env` off the web.

## Flask (on your computer, through the tunnel)

Start the tunnel. Run it again after a reboot, sleep or Wi-Fi change.

```sh
ssh -f -N artemis-tunnel
```

Then set up the project:

```sh
cd rate-your-professor
python3 -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
pip install flask mariadb python-dotenv
cp .env.example .env               # fill in DB_USER and DB_PASSWORD
```

On a Mac, `pip install mariadb` needs MariaDB's C library first:
`brew install mariadb-connector-c`.

To stop the tunnel: `pkill -f "ssh -f -N artemis-tunnel"`.

## Working with the database

**`csubryp` is shared.** `tables.sql` starts by dropping every table, so
running it on `csubryp` wipes everyone's data.

Test schema changes on your personal database first. It has the same name as
your Artemis username.

```sh
ssh artemis
cd ~/ryp/sql
(echo "SET foreign_key_checks=0;"; cat tables.sql data.sql; echo "SET foreign_key_checks=1;") | mariadb YOUR_ARTEMIS_USERNAME
```

Don't use `csubryp.sql` for this. Its first line is `USE csubryp`.

## Team rules

- `main` is protected. Make a branch and open a pull request.
- Change the schema only through a PR that edits `sql/tables.sql`. A renamed
  column breaks both the PHP and Flask pages.
- Never commit `.env` or `php/config.php`. Both are gitignored.
- Never put `.env` inside `public_html`. Apache would serve it as plain text,
  password included.
- Hash passwords with bcrypt (`$2y$`, what PHP's `password_hash` makes). In
  Flask, check them with the `bcrypt` package, not Werkzeug's
  `generate_password_hash`, which PHP can't read.
- Logins don't carry over between the PHP and Flask pages. Keep everything that
  needs a login in one of them.
