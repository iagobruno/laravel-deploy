<?php

namespace App\Jobs;

use App\Models\Log;
use Exception;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Context;
use Illuminate\Support\Facades\Process;
use Throwable;

class BadJob implements ShouldQueue
{
    use Queueable;

    /**
     * Create a new job instance.
     */
    public function __construct()
    {
        //
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $log = Log::create([
            'message' => '⏳ Processing...'
        ]);

        sleep(1);

        try {
            if ($this->attempts() <= 2) {
                throw new Exception('❌ Ocorreu um erro durante a execução do Job');
            }

            $result = Process::path(base_path())->run("php artisan inspire");
            $emoji = $result->successful() ? '✅' : '❌';
            $output = $result->successful() ? $result->output() : 'Failed to process the command' ?? $result->errorOutput();
            $output = preg_replace('/\e\[[0-9;]*m/', '', $output);
            $message = $emoji . ' ' . $output;

            $log->update(compact('message'));
        } catch (\Throwable $err) {
            $log->update([
                'message' => $err->getMessage(),
            ]);
            throw $err;
        }
    }
}
