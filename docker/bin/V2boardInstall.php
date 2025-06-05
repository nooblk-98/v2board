<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Encryption\Encrypter;
use App\Models\User;
use App\Utils\Helper;
use Illuminate\Support\Facades\DB;

class V2boardInstall extends Command
{
    protected $signature = 'v2board:install';
    protected $description = 'V2board installation command';

    public function __construct()
    {
        parent::__construct();
    }

    public function handle()
    {
        try {
            $this->info("__     ______  ____                      _  ");
            $this->info("\ \   / /___ \| __ )  ___   __ _ _ __ __| | ");
            $this->info(" \ \ / /  __) |  _ \ / _ \ / _` | '__/ _` | ");
            $this->info("  \ V /  / __/| |_) | (_) | (_| | | | (_| | ");
            $this->info("   \_/  |_____|____/ \___/ \__,_|_|  \__,_| ");

            if (\File::exists(base_path() . '/.env')) {
                $securePath = config('v2board.secure_path', config('v2board.frontend_admin_path', hash('crc32b', config('app.key'))));
                $this->info("Visit http(s)://your-domain/{$securePath} to access the admin panel. You can change your password from the user center.");
                abort(500, 'To reinstall, please delete the .env file in the directory.');
            }

            if (!copy(base_path() . '/.env.example', base_path() . '/.env')) {
                abort(500, 'Failed to copy the environment file. Please check directory permissions.');
            }

            $this->saveToEnv([
                'APP_KEY' => 'base64:' . base64_encode(Encrypter::generateKey('AES-256-CBC')),
                'DB_HOST' => env('DB_HOST', 'mariadb'),
                'DB_DATABASE' => env('DB_DATABASE', 'v2board'),
                'DB_USERNAME' => env('DB_USERNAME', 'v2boarduser'),
                'DB_PASSWORD' => env('DB_PASSWORD', 'v2boarduser123'),
            ]);

            \Artisan::call('config:clear');
            \Artisan::call('config:cache');

            try {
                DB::connection()->getPdo();
            } catch (\Exception $e) {
                abort(500, 'Database connection failed.');
            }

            $file = \File::get(base_path() . '/database/install.sql');
            if (!$file) {
                abort(500, 'Database SQL file not found.');
            }

            $sql = str_replace("\n", "", $file);
            $sql = preg_split("/;/", $sql);
            if (!is_array($sql)) {
                abort(500, 'Database SQL file format error.');
            }

            $this->info('Importing database, please wait...');
            foreach ($sql as $item) {
                try {
                    DB::select(DB::raw($item));
                } catch (\Exception $e) {
                    // skip failed queries
                }
            }

            $this->info('Database import completed.');

            $email = env('ADMIN_MAIL');
            $password = env('ADMIN_PASSWORD');

            if (!$email || !$password) {
                $this->error('Missing admin credentials: set ADMIN_MAIL and ADMIN_PASSWORD in .env or container env');
                return 1; // Exit with failure
            }

            if (!$this->registerAdmin($email, $password)) {
                abort(500, 'Admin registration failed, please try again.');
            }

            $this->info("Admin registered. Email: $email, Password: $password");

            $defaultSecurePath = hash('crc32b', config('app.key'));
            $this->info("Visit http(s)://your-domain/{$defaultSecurePath} to access the admin panel. You can change your password from the user center.");
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    private function registerAdmin($email, $password)
    {
        $user = new User();
        $user->email = $email;
        if (strlen($password) < 8) {
            abort(500, 'Admin password must be at least 8 characters long.');
        }
        $user->password = password_hash($password, PASSWORD_DEFAULT);
        $user->uuid = Helper::guid(true);
        $user->token = Helper::guid();
        $user->is_admin = 1;
        return $user->save();
    }

    private function saveToEnv($data = [])
    {
        function set_env_var($key, $value)
        {
            if (!is_bool(strpos($value, ' '))) {
                $value = '"' . $value . '"';
            }
            $key = strtoupper($key);
            $envPath = app()->environmentFilePath();
            $contents = file_get_contents($envPath);

            preg_match("/^{$key}=[^\r\n]*/m", $contents, $matches);
            $oldValue = count($matches) ? $matches[0] : '';

            if ($oldValue) {
                $contents = str_replace("{$oldValue}", "{$key}={$value}", $contents);
            } else {
                $contents = $contents . "\n{$key}={$value}\n";
            }

            $file = fopen($envPath, 'w');
            fwrite($file, $contents);
            return fclose($file);
        }

        foreach ($data as $key => $value) {
            set_env_var($key, $value);
        }
        return true;
    }
}
