<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required_without:phone|email',
            'phone' => 'required_without:email|string',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'messages' => $validator->errors()
            ], 422);
        }

        // Find user by email or phone
        $user = null;
        if ($request->email) {
            $user = User::where('email', $request->email)->first();
        } elseif ($request->phone) {
            $user = User::where('phone', $request->phone)->first();
        }

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'error' => 'Invalid credentials'
            ], 401);
        }

        return response()->json([
            'message' => 'Login successful',
            'user' => $user,
            'token' => 'mock-token-' . $user->id // In production, use actual tokens
        ]);
    }

    public function register(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'phone' => 'required|string|unique:users,phone',
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'messages' => $validator->errors()
            ], 422);
        }

        $data = $validator->validated();
        $data['password'] = Hash::make($data['password']);
        $data['role'] = 'USER'; // Regular users are always USER role
        
        $user = User::create($data);

        broadcast(new \App\Events\UserCreated($user));

        return response()->json([
            'message' => 'Registration successful',
            'user' => $user,
            'token' => 'mock-token-' . $user->id
        ], 201);
    }

    public function adminLogin(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'messages' => $validator->errors()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'error' => 'Invalid credentials'
            ], 401);
        }

        if (!$user->isAdmin()) {
            return response()->json([
                'error' => 'Access denied. Admin privileges required.'
            ], 403);
        }

        return response()->json([
            'message' => 'Admin login successful',
            'user' => $user,
            'token' => 'admin-token-' . $user->id
        ]);
    }

    public function createAdmin(Request $request): JsonResponse
    {
        // This endpoint should only be accessible by existing admins
        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'phone' => 'required|string|unique:users,phone',
            'password' => 'required|string|min:8',
            'admin_token' => 'required|string', // Simple admin verification
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'messages' => $validator->errors()
            ], 422);
        }

        // Verify admin token (simplified - in production use proper auth)
        if (!str_starts_with($request->admin_token, 'admin-token-')) {
            return response()->json([
                'error' => 'Unauthorized. Admin privileges required.'
            ], 403);
        }

        $data = $validator->validated();
        unset($data['admin_token']);
        $data['password'] = Hash::make($data['password']);
        $data['role'] = 'ADMIN';
        
        $admin = User::create($data);

        broadcast(new \App\Events\UserCreated($admin));

        return response()->json([
            'message' => 'Admin account created successfully',
            'admin' => $admin
        ], 201);
    }

    public function me(Request $request): JsonResponse
    {
        // Mock current user retrieval
        $token = $request->header('Authorization');
        if (!$token) {
            return response()->json(['error' => 'No token provided'], 401);
        }

        // Extract user ID from token
        $userId = str_replace(['mock-token-', 'admin-token-'], '', $token);
        $user = User::find($userId);

        if (!$user) {
            return response()->json(['error' => 'Invalid token'], 401);
        }

        return response()->json(['user' => $user]);
    }
}
