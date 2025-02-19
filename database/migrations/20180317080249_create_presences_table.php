<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePresencesTable extends Migration
{
    public function up()
    {
        Schema::create('presences', function (Blueprint $table) {
            // ...existing column definitions...
            $table->string('session_id', 32);
            $table->string('jid', 64);
            // Change from nullable() to notNullable()
            //$table->string('resource', 128)->nullable();
            $table->string('resource', 128)->notNullable();
            $table->integer('value');
            $table->integer('priority');
            $table->string('status', 255)->nullable();
            $table->string('node', 255)->nullable();
            $table->dateTime('delay')->nullable();
            $table->integer('last')->nullable();
            $table->tinyInteger('muc');
            $table->string('mucjid', 255)->nullable();
            $table->string('mucaffiliation', 32)->nullable();
            $table->string('mucrole', 32)->nullable();
            $table->timestamps();
            $table->primary(['session_id', 'jid', 'resource']);
            // ...existing column definitions...
        });
    }
    
    public function down()
    {
        Schema::dropIfExists('presences');
    }
}
