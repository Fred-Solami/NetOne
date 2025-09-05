<?php

use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\LocationController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProductController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Authentication Routes
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/admin-login', [AuthController::class, 'adminLogin']);
Route::post('/auth/create-admin', [AuthController::class, 'createAdmin']);
Route::get('/auth/me', [AuthController::class, 'me']);

// API Routes
Route::apiResource('users', UserController::class);
Route::apiResource('orders', OrderController::class);
Route::apiResource('locations', LocationController::class);
Route::apiResource('categories', CategoryController::class);
Route::apiResource('products', ProductController::class);

// Health check
Route::get('/health', function () {
    return response()->json([
        'status' => 'OK',
        'timestamp' => now(),
        'service' => 'NetOne Order Management API'
    ]);
});
