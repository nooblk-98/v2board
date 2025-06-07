# 🚀 V2Board Dockerized Deployment

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
- 🧠 `.env` detection + auto `v2board:install`

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

## 🚀 Deployment Guide

### 1. 📁 Create `.env` (optional)

If `.env` is not present on first run, the container auto-runs:

```bash
php artisan v2board:install
```

Or you can copy the default:

```bash
cp docker/configurations/.env.example .env
```

---

### 2. ▶️ Start the Stack

```bash
docker compose up -d
```

---

### 3. 🔍 Access the Web UI

Visit: [http://localhost:8080](http://localhost:8080)

---

## 🔐 Admin Login Details

Your admin credentials and access URL are printed in the container logs on first startup.

### 🧾 Default Credentials:

* **Email:** `admin@admin.com`
* **Password:** `admin@123+`

Set via `docker-compose.yml` → `environment:` section.

### 📜 Retrieve the Admin Link

Run this to find your admin login URL:

```bash
docker logs v2board | grep -i admin
```

Sample output:

```
Admin registered. Email: admin@admin.com, Password: admin@123+
Visit http(s)://your-domain/ff8f4b24 to access the admin panel.
```

> Replace `your-domain` with your actual domain or public IP.

---

## 🛠 Fix Permissions (if needed)

If Laravel can't write to `storage/` or `bootstrap/cache`, run:

```bash
docker exec -u root v2board chown -R www-data:www-data /var/www/html
```

---

## 🧩 Base Image Details

The `ghcr.io/nooblk-98/php-docker-nginx:php82` base image includes:

* 🧠 PHP 8.2 (FPM) on Alpine Linux
* 🚀 Nginx with public folder root
* 🔁 Supervisor to manage services
* 🧰 PHP Extensions:

  * `pdo_mysql`, `redis`, `curl`, `mbstring`, `gd`, `imagick`, `soap`, `intl`, `bcmath`, etc.
* 🎯 Optimized for Laravel/V2Board production workloads

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

```

---
