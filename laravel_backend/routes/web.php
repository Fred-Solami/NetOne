<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardController;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/dashboard', [DashboardController::class, 'index']);
Route::get('/api/dashboard/stats', [DashboardController::class, 'apiStats']);
Route::get('/api/dashboard/logs', [DashboardController::class, 'apiLogs']);
