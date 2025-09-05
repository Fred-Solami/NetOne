<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'category_id',
        'name',
        'description',
        'price',
        'unit',
        'type',
        'specifications',
        'image_url',
        'is_active',
        'sort_order',
        'stock_quantity',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'specifications' => 'array',
        'is_active' => 'boolean',
        'sort_order' => 'integer',
        'stock_quantity' => 'integer',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeInStock($query)
    {
        return $query->where(function ($q) {
            $q->whereNull('stock_quantity')
              ->orWhere('stock_quantity', '>', 0);
        });
    }

    public function scopeServices($query)
    {
        return $query->where('type', 'SERVICE');
    }

    public function scopeProducts($query)
    {
        return $query->where('type', 'PRODUCT');
    }

    public function isInStock()
    {
        return $this->stock_quantity === null || $this->stock_quantity > 0;
    }

    public function isService()
    {
        return $this->type === 'SERVICE';
    }

    public function isProduct()
    {
        return $this->type === 'PRODUCT';
    }
}
