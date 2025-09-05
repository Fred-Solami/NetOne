<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create sample locations
        \App\Models\Location::create([
            'name' => 'Lusaka City Center',
            'latitude' => -15.3875,
            'longitude' => 28.3228,
            'address' => 'Cairo Road, Lusaka, Zambia'
        ]);

        \App\Models\Location::create([
            'name' => 'Kitwe Business District',
            'latitude' => -12.8024,
            'longitude' => 28.2132,
            'address' => 'Independence Avenue, Kitwe, Zambia'
        ]);

        \App\Models\Location::create([
            'name' => 'Ndola Town Center',
            'latitude' => -12.9587,
            'longitude' => 28.6366,
            'address' => 'Buteko Avenue, Ndola, Zambia'
        ]);
    }
}
