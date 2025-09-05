#!/bin/bash

echo "=== NetOne Order Management API Demo ==="
echo "Backend running at: http://10.195.7.138:8000/api"
echo ""

echo "1. Health Check:"
curl -s http://10.195.7.138:8000/api/health | jq
echo ""

echo "2. List Users:"
curl -s http://10.195.7.138:8000/api/users | jq
echo ""

echo "3. List Locations:"
curl -s http://10.195.7.138:8000/api/locations | jq
echo ""

echo "4. List Orders (with VAT calculation):"
curl -s http://10.195.7.138:8000/api/orders | jq
echo ""

echo "=== Demo: Create new order with 16% VAT ==="
echo "Creating order for K500.00..."
curl -s -X POST http://10.195.7.138:8000/api/orders \
     -H 'Content-Type: application/json' \
     -d '{"user_id":2,"location_id":2,"amount":500.00,"vat_rate":16.0,"description":"Demo order - K500 + 16% VAT = K580"}' | jq

echo ""
echo "=== API Features Demonstrated ==="
echo "✓ User registration (first_name, last_name required)"
echo "✓ Location management (GPS coordinates)"
echo "✓ Order processing with automatic 16% VAT calculation"
echo "✓ Real-time API responses"
echo "✓ JSON validation and error handling"
echo ""
echo "Flutter APK built with backend URL: http://10.195.7.138:8000/api"
