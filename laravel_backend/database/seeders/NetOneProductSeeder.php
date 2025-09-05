<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use App\Models\Product;

class NetOneProductSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Enterprise Software Development
        $enterpriseSoftware = Category::create([
            'name' => 'Enterprise Software Development',
            'description' => 'Custom software solutions for businesses and enterprises',
            'icon' => 'code',
            'sort_order' => 1
        ]);

        Product::create([
            'category_id' => $enterpriseSoftware->id,
            'name' => 'Custom Web Application Development',
            'description' => 'Full-stack web application development using modern technologies',
            'price' => 5000.00,
            'unit' => 'project',
            'type' => 'SERVICE',
            'specifications' => [
                'technologies' => ['Laravel', 'React', 'Vue.js', 'Node.js'],
                'includes' => ['UI/UX Design', 'Database Design', 'Testing', 'Deployment']
            ]
        ]);

        Product::create([
            'category_id' => $enterpriseSoftware->id,
            'name' => 'Mobile App Development',
            'description' => 'Native and cross-platform mobile applications',
            'price' => 8000.00,
            'unit' => 'project',
            'type' => 'SERVICE',
            'specifications' => [
                'platforms' => ['iOS', 'Android', 'Flutter', 'React Native'],
                'includes' => ['UI/UX Design', 'Backend API', 'App Store Deployment']
            ]
        ]);

        Product::create([
            'category_id' => $enterpriseSoftware->id,
            'name' => 'Enterprise Resource Planning (ERP)',
            'description' => 'Complete ERP solution for business management',
            'price' => 15000.00,
            'unit' => 'license',
            'type' => 'SERVICE',
            'specifications' => [
                'modules' => ['Finance', 'HR', 'Inventory', 'Sales', 'Procurement'],
                'deployment' => 'Cloud or On-premise'
            ]
        ]);

        // 2. Cloud Infrastructure Hosting
        $cloudInfra = Category::create([
            'name' => 'Cloud Infrastructure Hosting',
            'description' => 'Scalable cloud hosting solutions and infrastructure services',
            'icon' => 'cloud',
            'sort_order' => 2
        ]);

        Product::create([
            'category_id' => $cloudInfra->id,
            'name' => 'Virtual Private Server (VPS)',
            'description' => 'High-performance virtual servers with full root access',
            'price' => 50.00,
            'unit' => 'month',
            'type' => 'SERVICE',
            'specifications' => [
                'cpu' => '2 vCPU',
                'ram' => '4GB RAM',
                'storage' => '80GB SSD',
                'bandwidth' => 'Unlimited'
            ]
        ]);

        Product::create([
            'category_id' => $cloudInfra->id,
            'name' => 'Cloud Storage',
            'description' => 'Secure and scalable cloud storage solution',
            'price' => 10.00,
            'unit' => '100GB/month',
            'type' => 'SERVICE',
            'specifications' => [
                'redundancy' => '99.99% uptime',
                'encryption' => 'AES-256',
                'backup' => 'Daily automated backups'
            ]
        ]);

        Product::create([
            'category_id' => $cloudInfra->id,
            'name' => 'Content Delivery Network (CDN)',
            'description' => 'Global CDN for faster content delivery',
            'price' => 25.00,
            'unit' => 'month',
            'type' => 'SERVICE',
            'specifications' => [
                'locations' => '50+ Global Locations',
                'ssl' => 'Free SSL Certificates',
                'analytics' => 'Real-time Analytics'
            ]
        ]);

        // 3. Cybersecurity
        $cybersecurity = Category::create([
            'name' => 'Cybersecurity',
            'description' => 'Comprehensive security solutions to protect your business',
            'icon' => 'shield',
            'sort_order' => 3
        ]);

        Product::create([
            'category_id' => $cybersecurity->id,
            'name' => 'Security Assessment & Penetration Testing',
            'description' => 'Comprehensive security audit and vulnerability assessment',
            'price' => 2500.00,
            'unit' => 'assessment',
            'type' => 'SERVICE',
            'specifications' => [
                'scope' => ['Network Security', 'Web Applications', 'Mobile Apps'],
                'deliverables' => 'Detailed Report with Remediation Plan'
            ]
        ]);

        Product::create([
            'category_id' => $cybersecurity->id,
            'name' => 'Managed Security Services',
            'description' => '24/7 security monitoring and incident response',
            'price' => 500.00,
            'unit' => 'month',
            'type' => 'SERVICE',
            'specifications' => [
                'monitoring' => '24/7 SOC Monitoring',
                'response' => 'Incident Response Team',
                'reporting' => 'Monthly Security Reports'
            ]
        ]);

        // 4. FinTech Solutions
        $fintech = Category::create([
            'name' => 'FinTech Solutions',
            'description' => 'Financial technology solutions for modern businesses',
            'icon' => 'credit-card',
            'sort_order' => 4
        ]);

        Product::create([
            'category_id' => $fintech->id,
            'name' => 'Payment Gateway Integration',
            'description' => 'Secure payment processing for e-commerce and mobile apps',
            'price' => 1500.00,
            'unit' => 'integration',
            'type' => 'SERVICE',
            'specifications' => [
                'methods' => ['Credit Cards', 'Mobile Money', 'Bank Transfers'],
                'security' => 'PCI DSS Compliant',
                'currencies' => 'Multi-currency Support'
            ]
        ]);

        Product::create([
            'category_id' => $fintech->id,
            'name' => 'Digital Banking Platform',
            'description' => 'Complete digital banking solution',
            'price' => 25000.00,
            'unit' => 'license',
            'type' => 'SERVICE',
            'specifications' => [
                'features' => ['Account Management', 'Loan Processing', 'Investment Portal'],
                'compliance' => 'Regulatory Compliant',
                'integration' => 'Core Banking Integration'
            ]
        ]);

        // 5. Data Centers
        $dataCenters = Category::create([
            'name' => 'Data Centers',
            'description' => 'Enterprise-grade data center and colocation services',
            'icon' => 'server',
            'sort_order' => 5
        ]);

        Product::create([
            'category_id' => $dataCenters->id,
            'name' => 'Colocation Services',
            'description' => 'Secure data center space for your servers',
            'price' => 200.00,
            'unit' => 'rack unit/month',
            'type' => 'SERVICE',
            'specifications' => [
                'power' => 'Redundant Power Supply',
                'cooling' => 'Climate Controlled',
                'security' => '24/7 Physical Security',
                'connectivity' => 'Multiple ISP Connections'
            ]
        ]);

        Product::create([
            'category_id' => $dataCenters->id,
            'name' => 'Disaster Recovery as a Service',
            'description' => 'Cloud-based disaster recovery solution',
            'price' => 1000.00,
            'unit' => 'month',
            'type' => 'SERVICE',
            'specifications' => [
                'rto' => 'Recovery Time Objective: 4 hours',
                'rpo' => 'Recovery Point Objective: 1 hour',
                'testing' => 'Quarterly DR Testing'
            ]
        ]);

        // 6. NEO Laptops (Hardware)
        $neoLaptops = Category::create([
            'name' => 'NEO Laptops',
            'description' => 'Locally manufactured high-quality laptops',
            'icon' => 'laptop',
            'sort_order' => 6
        ]);

        Product::create([
            'category_id' => $neoLaptops->id,
            'name' => 'NEO Business Pro',
            'description' => 'Professional laptop for business users',
            'price' => 1200.00,
            'unit' => 'each',
            'type' => 'PRODUCT',
            'stock_quantity' => 50,
            'specifications' => [
                'processor' => 'Intel Core i7',
                'ram' => '16GB DDR4',
                'storage' => '512GB SSD',
                'display' => '15.6" Full HD',
                'os' => 'Windows 11 Pro',
                'warranty' => '3 Years Local Warranty'
            ]
        ]);

        Product::create([
            'category_id' => $neoLaptops->id,
            'name' => 'NEO Student Edition',
            'description' => 'Affordable laptop for students and basic use',
            'price' => 600.00,
            'unit' => 'each',
            'type' => 'PRODUCT',
            'stock_quantity' => 100,
            'specifications' => [
                'processor' => 'Intel Core i5',
                'ram' => '8GB DDR4',
                'storage' => '256GB SSD',
                'display' => '14" HD',
                'os' => 'Windows 11 Home',
                'warranty' => '2 Years Local Warranty'
            ]
        ]);

        Product::create([
            'category_id' => $neoLaptops->id,
            'name' => 'NEO Gaming Elite',
            'description' => 'High-performance gaming laptop',
            'price' => 2500.00,
            'unit' => 'each',
            'type' => 'PRODUCT',
            'stock_quantity' => 20,
            'specifications' => [
                'processor' => 'Intel Core i9',
                'ram' => '32GB DDR4',
                'storage' => '1TB SSD + 1TB HDD',
                'display' => '17.3" 4K Gaming Display',
                'gpu' => 'NVIDIA RTX 4070',
                'os' => 'Windows 11 Pro',
                'warranty' => '3 Years Premium Support'
            ]
        ]);
    }
}
