<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call([
            TeacherDetailsSeeder::class,
            StudentDetailsSeeder::class,
            ClassSeeder::class,
            SubjectSeeder::class,
            CommentsSeeder::class,
        ]);
    }
}
