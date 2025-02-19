Schema::create('presences', function (Blueprint $table) {
    $table->string('session_id', 32);
    $table->string('jid', 64);
    // Changed from nullable to non-nullable; add a default if needed.
    $table->string('resource', 128)->default('');
    $table->integer('value');
    $table->integer('priority');
    $table->string('status', 255)->nullable();
    $table->string('node', 255)->nullable();
    $table->dateTime('delay')->nullable();
    $table->integer('last')->nullable();
    $table->boolean('muc');
    $table->string('mucjid', 255)->nullable();
    $table->string('mucaffiliation', 32)->nullable();
    $table->string('mucrole', 32)->nullable();
    $table->timestamps();
    $table->primary(['session_id', 'jid', 'resource']);
});
