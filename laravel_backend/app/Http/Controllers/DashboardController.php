<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Location;
use App\Models\Order;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class DashboardController extends Controller
{
    public function index()
    {
        return view('dashboard.index', [
            'userCount' => User::count(),
            'locationCount' => Location::count(),
            'orderCount' => Order::count(),
            'totalRevenue' => Order::sum('calculated_total_amount'),
            'recentUsers' => User::latest()->take(5)->get(),
            'recentOrders' => Order::with('user', 'location')->latest()->take(5)->get(),
        ]);
    }
    
    public function apiStats()
    {
        return response()->json([
            'status' => 'NetOne Backend Running',
            'timestamp' => now()->toISOString(),
            'statistics' => [
                'total_users' => User::count(),
                'total_locations' => Location::count(),
                'total_orders' => Order::count(),
                'total_revenue' => number_format(Order::sum('calculated_total_amount'), 2),
                'server_uptime' => $this->getServerUptime(),
                'api_health' => 'OK',
            ],
            'recent_activity' => [
                'last_user' => User::latest()->first()?->first_name . ' ' . User::latest()->first()?->last_name,
                'last_order' => 'Order #' . Order::latest()->first()?->id,
                'last_location' => Location::latest()->first()?->name,
            ],
            'database_status' => 'Connected',
            'api_version' => '1.0.0',
            'company' => 'NetOne Zambia',
        ]);
    }
    
    private function getServerUptime()
    {
        if (PHP_OS_FAMILY === 'Linux') {
            $uptime = shell_exec('uptime -p') ?: 'Unknown';
            return trim($uptime);
        }
        return 'Running';
    }
    
    public function apiLogs()
    {
        try {
            $logFile = storage_path('logs/laravel.log');
            if (file_exists($logFile)) {
                $logs = collect(file($logFile))
                    ->reverse()
                    ->take(50)
                    ->map(function ($line) {
                        return trim($line);
                    })
                    ->filter(function ($line) {
                        return str_contains($line, 'API REQUEST') || str_contains($line, 'API RESPONSE');
                    })
                    ->take(20)
                    ->values();
                    
                return response()->json([
                    'status' => 'success',
                    'logs' => $logs,
                    'count' => count($logs),
                ]);
            }
            
            return response()->json([
                'status' => 'success',
                'logs' => ['No logs available yet'],
                'count' => 0,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Unable to read logs',
                'logs' => [],
                'count' => 0,
            ]);
        }
    }
}
