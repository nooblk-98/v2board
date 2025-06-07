# V2Board Dockerized Deployment

A fully Dockerized, production-ready container image for [V2Board](https://github.com/v2board/v2board), running on Alpine Linux with **PHP 8.2 (FPM)**, **Nginx**, **Supervisor**, **Redis**, and **MariaDB**.

This setup is optimized for performance, portability, and maintainability.

---

## 📦 Features

- 🐳 PHP 8.2 FPM with Laravel + V2Board
- 🔧 Supervisor-managed process control (Nginx, PHP-FPM, Scheduler)
- ⚡ Composer pre-installed
- 🔄 Laravel scheduler auto-run enabled
- 🧰 Includes common PHP extensions: `pdo_mysql`, `redis`, `curl`, `gd`, `imagick`, `soap`, `intl`, etc.
- 🔐 Secure, production-optimized Alpine Linux base
- 🧠 `.env` detection + auto `v2board:install` on first run

---

## 🛠 Docker Compose Stack

```yaml
services:
  web:
    image: ghcr.io/nooblk-98/v2board-docker:latest
    container_name: v2board
    environment:
      ADMIN_MAIL: admin@admin.com
      ADMIN_PASSWORD: admin@123+
    ports:
      - "8080:80"
    depends_on:
      - mariadb
      - redis
    volumes:
      - web_data:/var/www/html

  mariadb:
    image: mariadb:10
    container_name: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: v2board123+
      MYSQL_DATABASE: v2board
      MYSQL_USER: v2boarduser
      MYSQL_PASSWORD: "v2boarduser123"
    volumes:
      - db_data:/var/lib/mysql
    ports:
      - "3306:3306"

  redis:
    image: redis:latest
    container_name: redis

volumes:
  db_data:
  web_data:
````

---

## Deployment Guide

### 🛠 Start the Stack

```bash
docker compose up -d
```

### 🛠 Fix Permissions

If Laravel encounters permission issues (e.g., can't write to `storage/` or `bootstrap/cache`), run:

```bash
docker exec -u root v2board chown -R www-data:www-data /var/www/html
```

---

### 🛠 Access the Web UI

Visit: [http://localhost:8080](http://localhost:8080)

---

## 🔐 Admin Login Details

Your admin credentials and access URL are printed in the container logs on first startup.

### 🧾 Default Credentials:

* **Email:** `admin@admin.com`
* **Password:** `admin@123+`

These are set in `docker-compose.yml` under the `environment:` section.

### 📜 Retrieve the Admin Link

To retrieve your admin login URL:

```bash
docker logs v2board | grep -i admin
```

Example:

```
Admin registered. Email: admin@admin.com, Password: admin@123+
Visit http(s)://your-domain/ff8f4b24 to access the admin panel.
```

> Replace `your-domain` with your real domain or public IP address.

---

### 🔁 Reset Admin Credentials

To reinitialize the app with a new admin account:

```bash
docker exec -it v2board rm -f /var/www/html/.env
docker restart v2board
```

This will trigger auto-installation and re-register a new admin using updated environment variables.

---

### 📘 Full Setup Guide

For a complete step-by-step guide, visit:

🛠 **[V2Board Docker Deployment Guide](https://www.itsnooblk.com/posts/v2board-docker/)**

## 🧩 Base Image Details

The `ghcr.io/nooblk-98/php-docker-nginx:php82` base image includes:

* 🧠 PHP 8.2 (FPM) on Alpine Linux
* 🚀 Nginx with Laravel-compatible `/public` root
* 🔁 Supervisor to manage services
* 🧰 PHP Extensions:

  * `pdo_mysql`, `redis`, `curl`, `mbstring`, `gd`, `imagick`, `soap`, `intl`, `bcmath`, `opcache`, and more
* 🛠 Designed for Laravel/V2Board deployments

---

## 👨‍💻 Maintainer

**Liyanage L.S.**
📬 `liyanagelsofficial@gmail.com`

---

## 📄 License

MIT — free to use, fork, and modify.

---

## 🌐 Credits

* [V2Board](https://github.com/v2board/v2board)
* [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer)
* [Official PHP Docker images](https://hub.docker.com/_/php)
