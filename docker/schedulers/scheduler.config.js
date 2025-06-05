module.exports = {
  apps: [
    {
        name: "schedule:run",
        script: "php",
        args: "artisan schedule:run",
        cwd: "/var/www/html/",
        exec_mode: "fork",
        instances: 1,
        autorestart: false, // Important!
        watch: false,
        cron_restart: "*/1 * * * *",
        env: {
            APP_ENV: "production",
      },
    },
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
