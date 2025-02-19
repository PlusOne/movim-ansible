<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AlterPresencesResourceColumn extends Migration
{
    public function up()
    {
        Schema::table('presences', function (Blueprint $table) {
            // Force 'resource' to be non-nullable with a default value
            $table->string('resource', 128)->default('')->nullable(false)->change();
        });
    }

    public function down()
    {
        Schema::table('presences', function (Blueprint $table) {
            // Revert back to nullable if needed
            $table->string('resource', 128)->nullable()->change();
        });
    }
}
