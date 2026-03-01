// =============================
// GRAVEDAD
// =============================
if (vsp < 0)
    vsp += gravity_up;
else
    vsp += gravity_down;

// Aplicar gravedad con colisión
var vsp_move = vsp;
if (place_meeting(x, y + vsp_move, obj_solid)) {
    while (!place_meeting(x, y + sign(vsp_move), obj_solid)) {
        y += sign(vsp_move);
    }
    vsp = 0;
} else {
    y += vsp_move;
}

// =============================
// MUERTE
// =============================
if (hp <= 0) {
    instance_destroy();
    exit;
}

// =============================
// HIT (interrumpe todo)
// =============================
if (isHit) {
    if (sprite_index != SkeletonHit) {
        sprite_index = SkeletonHit;
        image_index = 0;
        image_speed = 1;
    }
    if (image_index >= image_number - 1) {
        isHit = false;
    }
    exit;
}

// =============================
// DETECTAR TARGET
// =============================
if (target == noone || !instance_exists(target)) {
    var nearest = instance_nearest(x, y, PlayerObj); // ← cambia oPlayer por tu objeto jugador
    if (nearest != noone) {
        var d = point_distance(x, y, nearest.x, nearest.y);
        if (d < vision_range) {
            target = nearest;
        }
    }
}

// =============================
// IA
// =============================
if (target != noone && instance_exists(target)) {
    var dist = point_distance(x, y, target.x, target.y);

    // ATACAR
    if (dist <= attack_range) {
    if (!isAttacking) {
        isAttacking = true;
        hasDealtDamage = false; // resetear por cada ataque nuevo
        sprite_index = SkeletonAttack;
        image_index = 0;
        image_speed = 1;
    }
    
    // Aplicar daño a la mitad de la animación (una sola vez)
    var hitFrame = floor(image_number / 2);
    if (floor(image_index) >= hitFrame && !hasDealtDamage) {
        hasDealtDamage = true;
        if (instance_exists(target) && point_distance(x, y, target.x, target.y) <= attack_range) {
            with (target) {
                hp -= 1; // daño
                isHit = true; // si el jugador tiene sistema de hit
            }
        }
    }
    
    if (image_index >= image_number - 1) {
        isAttacking = false;
    }
}
 else if (dist < vision_range) {
        isAttacking = false;
        var dir = sign(target.x - x);
        x += dir * move_speed;
        image_xscale = dir;
        if (sprite_index != SkeletonWalk) {
            sprite_index = SkeletonWalk;
            image_speed = 1;
        }

    // IDLE (perdió al jugador)
    } else {
        target = noone;
        isAttacking = false;
        if (sprite_index != SkeletonIdle) {
            sprite_index = SkeletonIdle;
            image_speed = 1;
        }
    }
}