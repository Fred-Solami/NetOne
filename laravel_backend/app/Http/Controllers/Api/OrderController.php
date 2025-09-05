<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    public function index(): JsonResponse
    {
        $orders = Order::with(['user', 'location'])->get();
        return response()->json($orders);
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'location_id' => 'required|exists:locations,id',
            'amount' => 'required|numeric|min:0',
            'vat_rate' => 'sometimes|numeric|min:0|max:100',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'messages' => $validator->errors()
            ], 422);
        }

        $data = $validator->validated();
        $data['vat_rate'] = $data['vat_rate'] ?? 16.00;

        $order = Order::create($data);
        $order->load(['user', 'location']);

        broadcast(new \App\Events\OrderCreated($order));

        return response()->json([
            'message' => 'Order created successfully',
            'order' => $order
        ], 201);
    }

    public function show(string $id): JsonResponse
    {
        $order = Order::with(['user', 'location'])->findOrFail($id);
        return response()->json($order);
    }

    public function update(Request $request, string $id): JsonResponse
    {
        $order = Order::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'user_id' => 'sometimes|required|exists:users,id',
            'location_id' => 'sometimes|required|exists:locations,id',
            'amount' => 'sometimes|required|numeric|min:0',
            'vat_rate' => 'sometimes|numeric|min:0|max:100',
            'status' => 'sometimes|string|in:pending,processing,completed,cancelled',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'messages' => $validator->errors()
            ], 422);
        }

        $data = $validator->validated();
        $order->update($data);
        $order->load(['user', 'location']);

        broadcast(new \App\Events\OrderUpdated($order));

        return response()->json([
            'message' => 'Order updated successfully',
            'order' => $order
        ]);
    }

    public function destroy(string $id): JsonResponse
    {
        $order = Order::findOrFail($id);
        $order->delete();

        broadcast(new \App\Events\OrderDeleted($id));

        return response()->json([
            'message' => 'Order deleted successfully'
        ]);
    }
}
