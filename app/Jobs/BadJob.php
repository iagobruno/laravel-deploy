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

        sleep(3);
        Context::set('log-id', $log->id);
        throw new Exception('Ocorreu um erro');

        $result = Process::path(base_path())->run("php artisan inspire");
        $emoji = $result->successful() ? '✅' : '❌';
        $output = $result->successful() ? $result->output() : 'Failed to process the command' ?? $result->errorOutput();
        $output = preg_replace('/\e\[[0-9;]*m/', '', $output);
        $message = $emoji . ' ' . $output;

        $log->update(compact('message'));
    }

    public function failed(?Throwable $exception): void
    {
        $logId = Context::get('log-id');
        Log::find($logId)?->update([
            'message' => '❌ Ocorreu um erro durante a execução do Job'
        ]);
    }
}
