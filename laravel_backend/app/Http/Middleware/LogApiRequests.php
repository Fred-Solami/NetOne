<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Log;

class LogApiRequests
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $startTime = microtime(true);
        
        // Log incoming request
        $logData = [
            'timestamp' => now()->toISOString(),
            'method' => $request->method(),
            'url' => $request->fullUrl(),
            'ip' => $request->ip(),
            'user_agent' => $request->userAgent(),
            'data' => $request->method() === 'POST' ? $request->all() : null,
        ];
        
        Log::info('🔵 API REQUEST', $logData);
        
        $response = $next($request);
        
        $endTime = microtime(true);
        $executionTime = round(($endTime - $startTime) * 1000, 2);
        
        // Log response
        $responseData = [
            'timestamp' => now()->toISOString(),
            'status' => $response->getStatusCode(),
            'execution_time_ms' => $executionTime,
            'response_size' => strlen($response->getContent()),
        ];
        
        if ($response->getStatusCode() >= 200 && $response->getStatusCode() < 300) {
            Log::info('✅ API RESPONSE SUCCESS', $responseData);
        } else {
            Log::warning('❌ API RESPONSE ERROR', $responseData);
        }
        
        return $response;
    }
}
