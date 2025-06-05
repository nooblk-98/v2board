module.exports = {
  apps: [
    {
        name: "horizon",
        script: "php",
        args: "artisan horizon",
        cwd: "/var/www/html/", 
        exec_mode: "fork",
        instances: 1, 
        autorestart: true,
        watch: false,
        max_memory_restart: "200M",
        env: {
            APP_ENV: "production",
      },
    },
  ],
};
