<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Location;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class LocationController extends Controller
{
    public function index(): JsonResponse
    {
        $locations = Location::with('orders')->get();
        return response()->json($locations);
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'latitude' => 'required|numeric|between:-90,90',
            'longitude' => 'required|numeric|between:-180,180',
            'address' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'messages' => $validator->errors()
            ], 422);
        }

        $data = $validator->validated();
        $location = Location::create($data);

        broadcast(new \App\Events\LocationCreated($location));

        return response()->json([
            'message' => 'Location created successfully',
            'location' => $location
        ], 201);
    }

    public function show(string $id): JsonResponse
    {
        $location = Location::with('orders')->findOrFail($id);
        return response()->json($location);
    }

    public function update(Request $request, string $id): JsonResponse
    {
        $location = Location::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|required|string|max:255',
            'latitude' => 'sometimes|required|numeric|between:-90,90',
            'longitude' => 'sometimes|required|numeric|between:-180,180',
            'address' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'messages' => $validator->errors()
            ], 422);
        }

        $data = $validator->validated();
        $location->update($data);

        broadcast(new \App\Events\LocationUpdated($location));

        return response()->json([
            'message' => 'Location updated successfully',
            'location' => $location
        ]);
    }

    public function destroy(string $id): JsonResponse
    {
        $location = Location::findOrFail($id);
        $location->delete();

        broadcast(new \App\Events\LocationDeleted($id));

        return response()->json([
            'message' => 'Location deleted successfully'
        ]);
    }
}
