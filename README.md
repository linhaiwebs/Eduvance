# Eduvance - 在线教育平台

Eduvance 是一个基于 Laravel 6 构建的在线教育管理系统，支持课程管理、视频课程、文档管理、学生/教师管理等功能。

## 📋 项目概述

### 功能模块
- **学生管理** - 注册、登录、信息管理
- **教师管理** - 注册、登录、权限管理（Admin/Teacher）
- **课程管理** - 班级(Classes)、科目(Subjects)、课程(Lessons)
- **视频课程** - 上传视频文件或嵌入 YouTube 链接
- **文档管理** - 上传课程相关文档
- **评论系统** - 学生对课程进行评论
- **联系信息** - 学校联系方式、用户反馈
- **AI 摘要** - 基于 Rev.ai API 的语音转文字摘要（可选）

### 技术栈
- **后端**: Laravel 6.x (PHP 7.2+)
- **数据库**: MySQL 5.7+
- **前端**: Blade 模板 + Laravel Mix (Sass/JS)
- **缓存**: Redis (可选)
- **Web 服务器**: Nginx / Apache

---

## 🚀 部署方式

### 方式一：本地开发部署（推荐新手）

#### 1. 系统要求
- PHP >= 7.2 (推荐 7.4)
- MySQL >= 5.7
- Node.js >= 12
- Composer >= 2.0
- 扩展: PDO, Mbstring, OpenSSL, Tokenizer, XML, Ctype, JSON, BCMath, GD, Zip

#### 2. 安装步骤

```bash
# 克隆项目
git clone <repository-url> eduvance
cd eduvance

# 安装 PHP 依赖
composer install

# 安装前端依赖
npm install

# 复制环境配置文件
cp .env.example .env

# 生成应用密钥
php artisan key:generate

# 配置数据库 (编辑 .env 文件)
# DB_DATABASE=eduvance
# DB_USERNAME=root
# DB_PASSWORD=your_password

# 创建 MySQL 数据库
mysql -u root -p
# CREATE DATABASE eduvance CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
# EXIT;

# 运行数据库迁移
php artisan migrate

# （可选）填充初始管理员数据
php artisan db:seed --class=TeacherDetailsSeeder

# 创建文件上传目录
mkdir -p public/public/Image
mkdir -p public/public/vedios
mkdir -p public/public/documents

# 设置目录权限
chmod -R 755 storage
chmod -R 755 bootstrap/cache
chmod -R 755 public/public

# 编译前端资源
npm run dev

# 启动开发服务器
php artisan serve
```

访问 http://localhost:8000 即可使用。

#### 3. 默认管理员账号
如果执行了 `TeacherDetailsSeeder`：
- **邮箱**: kamalperera@gmail.com
- **密码**: 123
- **角色**: Admin

---

### 方式二：Docker Compose 部署（推荐团队/测试）

#### 1. 前提条件
- Docker >= 20.10
- Docker Compose >= 2.0

#### 2. 使用分离式容器部署（App + Nginx + MySQL + Redis）

```bash
# 克隆项目
git clone <repository-url> eduvance
cd eduvance

# 使用 Docker 环境配置文件
cp .env.docker .env

# 启动所有服务
docker-compose up -d --build

# 等待 MySQL 就绪后，初始化应用
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed --class=TeacherDetailsSeeder

# 设置目录权限
docker-compose exec app chmod -R 755 storage
docker-compose exec app chmod -R 755 bootstrap/cache

# 编译前端资源
docker-compose exec app npm install
docker-compose exec app npm run dev

# 创建符号链接
docker-compose exec app php artisan storage:link
```

访问 http://localhost 即可使用。

#### 3. 使用单容器部署（全部集成）

```bash
# 使用 standalone 配置启动
docker-compose -f docker-compose.standalone.yml up -d --build

# 初始化
docker-compose -f docker-compose.standalone.yml exec eduvance php artisan key:generate
docker-compose -f docker-compose.standalone.yml exec eduvance php artisan migrate
docker-compose -f docker-compose.standalone.yml exec eduvance php artisan db:seed --class=TeacherDetailsSeeder
```

#### 4. Docker 常用命令

```bash
# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f mysql

# 停止所有服务
docker-compose down

# 停止并删除数据卷（重置数据库）
docker-compose down -v

# 重新构建镜像
docker-compose build --no-cache
```

---

### 方式三：生产环境部署（Nginx + PHP-FPM）

#### 1. 服务器要求
- Ubuntu 20.04+ / CentOS 7+
- PHP 7.4 FPM
- MySQL 5.7+
- Nginx 1.18+
- Redis (可选，推荐用于缓存和 Session)
- Supervisor (用于队列进程管理)

#### 2. 安装系统依赖

```bash
# Ubuntu
sudo apt update
sudo apt install -y nginx mysql-server php7.4-fpm php7.4-mysql php7.4-mbstring \
    php7.4-xml php7.4-gd php7.4-zip php7.4-bcmath php7.4-curl php7.4-json \
    php7.4-opcache redis-server supervisor unzip curl ffmpeg

# 安装 Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# 安装 Node.js
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs
```

#### 3. 部署应用

```bash
# 创建项目目录
sudo mkdir -p /var/www/eduvance
sudo chown -R $USER:$USER /var/www/eduvance

# 克隆项目
git clone <repository-url> /var/www/eduvance
cd /var/www/eduvance

# 安装依赖
composer install --optimize-autoloader --no-dev
npm install
npm run prod

# 配置环境
cp .env.production .env
php artisan key:generate

# 编辑 .env 文件，配置数据库和域名
nano .env
```

#### 4. 配置 .env 生产环境

```env
APP_NAME=Eduvance
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-domain.com

DB_DATABASE=eduvance
DB_USERNAME=eduvance_user
DB_PASSWORD=YOUR_SECURE_PASSWORD

CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=database
```

#### 5. 配置 MySQL

```bash
sudo mysql_secure_installation

sudo mysql
CREATE DATABASE eduvance CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'eduvance_user'@'localhost' IDENTIFIED BY 'YOUR_SECURE_PASSWORD';
GRANT ALL PRIVILEGES ON eduvance.* TO 'eduvance_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### 6. 初始化应用

```bash
php artisan migrate --force
php artisan db:seed --class=TeacherDetailsSeeder --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan storage:link

# 创建上传目录
mkdir -p public/public/Image
mkdir -p public/public/vedios
mkdir -p public/public/documents

# 设置权限
sudo chown -R www-data:www-data /var/www/eduvance
sudo chmod -R 755 /var/www/eduvance/storage
sudo chmod -R 755 /var/www/eduvance/bootstrap/cache
sudo chmod -R 755 /var/www/eduvance/public/public
```

#### 7. 配置 Nginx

```bash
sudo nano /etc/nginx/sites-available/eduvance
```

添加以下内容：

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    root /var/www/eduvance/public;
    index index.php index.html;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    charset utf-8;

    client_max_body_size 500M;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_read_timeout 300;
    }

    location ~ /\.(?!well-known.*) {
        deny all;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        access_log off;
        add_header Cache-Control "public, no-transform";
    }
}
```

```bash
# 启用站点配置
sudo ln -s /etc/nginx/sites-available/eduvance /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

#### 8. 配置 PHP-FPM

```bash
sudo nano /etc/php/7.4/fpm/php.ini
```

修改以下配置：

```ini
upload_max_filesize = 500M
post_max_size = 550M
max_execution_time = 300
memory_limit = 512M
```

```bash
sudo systemctl restart php7.4-fpm
```

#### 9. 配置 SSL (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

#### 10. 配置 Supervisor (队列进程)

```bash
sudo nano /etc/supervisor/conf.d/eduvance-worker.conf
```

```ini
[program:eduvance-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/eduvance/artisan queue:work database --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/www/eduvance/storage/logs/worker.log
stopwaitsecs=3600
```

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start eduvance-worker:*
```

---

## 📁 项目目录结构

```
Eduvance/
├── app/
│   ├── Http/Controllers/     # 控制器
│   │   ├── ClassesController.php
│   │   ├── CommentController.php
│   │   ├── ContactDetailController.php
│   │   ├── DocumentController.php
│   │   ├── GenerateSummeryController.php
│   │   ├── LessonController.php
│   │   ├── StudentController.php
│   │   ├── SubjectController.php
│   │   └── TeacherController.php
│   ├── Classes.php           # 班级模型
│   ├── Comment.php           # 评论模型
│   ├── ContactDetail.php     # 联系信息模型
│   ├── Document.php          # 文档模型
│   ├── Feedback.php          # 反馈模型
│   ├── Lesson.php            # 课程模型
│   ├── Student.php           # 学生模型
│   ├── Subject.php           # 科目模型
│   ├── Teacher.php           # 教师模型
│   ├── User.php              # 用户模型
│   └── VideoModel.php        # 视频观看记录模型
├── config/                   # 配置文件
├── database/
│   ├── migrations/           # 数据库迁移
│   └── seeds/                # 数据填充
├── docker/                   # Docker 配置
│   ├── mysql/my.cnf
│   ├── nginx/default.conf
│   ├── php/custom.ini
│   └── supervisor/laravel.conf
├── public/                   # Web 根目录
│   ├── public/
│   │   ├── Image/            # 课程缩略图
│   │   ├── vedios/           # 上传的视频
│   │   └── documents/        # 上传的文档
│   └── index.php
├── resources/
│   ├── views/                # Blade 模板
│   ├── js/                   # JavaScript
│   └── sass/                 # Sass 样式
├── routes/
│   ├── web.php               # Web 路由
│   └── api.php               # API 路由
├── .env.example              # 环境配置模板
├── .env.docker               # Docker 环境配置
├── .env.production           # 生产环境配置模板
├── Dockerfile                # 单容器 Docker 镜像
├── Dockerfile.fpm            # PHP-FPM Docker 镜像
├── docker-compose.yml        # 分离式 Docker 编排
└── docker-compose.standalone.yml  # 单容器 Docker 编排
```

## 💾 数据库说明

### 项目中没有 .sql 数据库文件？

**原始项目（上游仓库）没有提供任何数据库 dump 文件**，也没有 Supabase 配置。数据库结构完全通过 Laravel 的 Migration 机制定义。

现在项目已包含 `database/eduvance.sql` 完整数据库文件，你可以选择两种方式初始化数据库：

#### 方式 A：使用 SQL 文件直接导入（推荐快速部署）

```bash
# 创建数据库
mysql -u root -p -e "CREATE DATABASE eduvance CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 导入 SQL 文件
mysql -u root -p eduvance < database/eduvance.sql
```

#### 方式 B：使用 Laravel Migrations & Seeders

```bash
php artisan migrate
php artisan db:seed
```

### 数据库配置位置

| 配置项 | 文件位置 | 说明 |
|--------|---------|------|
| 数据库连接 | `.env` | DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD |
| 连接详情 | `config/database.php` | MySQL/PostgreSQL/SQLite/SQL Server 配置 |
| 表结构定义 | `database/migrations/` | 10 个迁移文件定义所有表 |
| 初始数据 | `database/seeds/` | 管理员账号、班级、科目等种子数据 |
| SQL 完整导出 | `database/eduvance.sql` | 建表 + 初始数据的完整 SQL 文件 |

### 默认账号

| 角色 | 邮箱 | 密码 |
|------|------|------|
| Admin (教师) | kamalperera@gmail.com | 123 |
| Student (学生) | sheraanmario777@gmail.com | 123 |

---

## 🗃️ 数据库表结构

| 表名 | 说明 |
|------|------|
| students | 学生信息 (username, email, password) |
| teachers | 教师信息 (username, email, password, role) |
| classes | 班级信息 (name, teacher_id) |
| subjects | 科目信息 (name, teacher_id, class_id) |
| lessons | 课程信息 (subject_id, lesson_name, lesson_thumbnail, lesson_vedio_link, platform_link) |
| comments | 评论 (student_id, display_name, email_address, message, lesson_id) |
| contact_details | 学校联系信息 (school_name, school_address, admin_name, admin_tel) |
| feedback | 用户反馈 (full_name, email_address, tel_no, message) |
| documents | 课程文档 (document_title, class_id, lesson_id, document_name) |
| video_models | 视频观看记录 (userId, lessonId) |

---

## ⚙️ 环境变量说明

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| APP_NAME | 应用名称 | Eduvance |
| APP_ENV | 环境 (local/production) | local |
| APP_DEBUG | 调试模式 | true |
| APP_URL | 应用 URL | http://localhost:8000 |
| DB_CONNECTION | 数据库类型 | mysql |
| DB_HOST | 数据库主机 | 127.0.0.1 |
| DB_PORT | 数据库端口 | 3306 |
| DB_DATABASE | 数据库名称 | eduvance |
| DB_USERNAME | 数据库用户名 | root |
| DB_PASSWORD | 数据库密码 | (空) |
| CACHE_DRIVER | 缓存驱动 | file |
| SESSION_DRIVER | Session 驱动 | file |
| MAIL_DRIVER | 邮件驱动 | smtp |
| REV_AI_TOKEN | Rev.ai API Token (可选) | (空) |
| FILESYSTEM_DRIVER | 文件系统驱动 | public |

---

## 🔧 常见问题

### 1. 权限问题
```bash
sudo chown -R www-data:www-data storage bootstrap/cache public/public
sudo chmod -R 755 storage bootstrap/cache public/public
```

### 2. 视频上传失败
- 检查 `php.ini` 中的 `upload_max_filesize` 和 `post_max_size`
- 检查 Nginx 的 `client_max_body_size`
- 确认 `public/public/vedios` 目录存在且有写权限

### 3. 数据库连接失败
- 检查 `.env` 中的数据库配置
- Docker 环境中 `DB_HOST` 应设为 `mysql` (容器名)
- 确认 MySQL 服务已启动

### 4. 500 错误
```bash
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
```

### 5. 前端资源未加载
```bash
npm install
npm run dev    # 开发环境
npm run prod   # 生产环境
```

---

## 📜 License

MIT License
