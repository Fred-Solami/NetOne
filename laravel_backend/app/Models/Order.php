<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'location_id',
        'order_number',
        'amount',
        'vat_rate',
        'vat_amount',
        'total_amount',
        'status',
        'description',
    ];

    protected $casts = [
        'amount' => 'decimal:2',
        'vat_rate' => 'decimal:2',
        'vat_amount' => 'decimal:2',
        'total_amount' => 'decimal:2',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function location()
    {
        return $this->belongsTo(Location::class);
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function calculateVat()
    {
        $this->vat_amount = ($this->amount * $this->vat_rate) / 100;
        $this->total_amount = $this->amount + $this->vat_amount;
    }

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($order) {
            $order->order_number = 'ORD-' . strtoupper(uniqid());
            $order->calculateVat();
        });

        static::updating(function ($order) {
            if ($order->isDirty(['amount', 'vat_rate'])) {
                $order->calculateVat();
            }
        });
    }
}
