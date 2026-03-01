// MOVIMIENTO HORIZONTAL
hsp = 0;
accel_ground = 0.6;
accel_air = 0.3;
friction = 0.5;
maxSpeed = 5;

// MOVIMIENTO VERTICAL
vsp = 0;
gravity_up = 0.5;
gravity_down = 0.8;
jump_force = -10;

// TOLERANCIAS
coyoteTimeMax = 6;
coyoteTimer = 0;

jumpBufferMax = 6;
jumpBuffer = 0;


base_scale = 2;
image_yscale = base_scale;
image_xscale = base_scale


// ATAQUE
isAttacking = false;
comboStep = 0;        // 0 = nada, 1 = combo, 2 = combo end
attackBuffer = 0;
attackBufferMax = 10; // frames para encadenar combo