// INPUT
var input_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var input_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var input_run   = keyboard_check(vk_shift);

var input_jump_pressed =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(ord("W")) ||
    keyboard_check_pressed(vk_up);

var input_jump_hold =
    keyboard_check(vk_space) ||
    keyboard_check(ord("W")) ||
    keyboard_check(vk_up);

var input_attack = mouse_check_button_pressed(mb_left) || keyboard_check(ord("X"));

var move = input_right - input_left;
var onGround = place_meeting(x, y + 1, obj_solid);


if (hp <= 0) {
    instance_destroy();
    exit;
}

//-------------------------------------------------
// COYOTE TIME
//-------------------------------------------------

if (onGround)
    coyoteTimer = coyoteTimeMax;
else
    coyoteTimer--;

if (input_jump_pressed)
    jumpBuffer = jumpBufferMax;
else
    jumpBuffer--;

if (jumpBuffer > 0 && coyoteTimer > 0)
{
    vsp = jump_force;
    jumpBuffer = 0;
    coyoteTimer = 0;
}


//-------------------------------------------------
// GRAVEDAD
//-------------------------------------------------

if (vsp < 0)
    vsp += gravity_up;
else
    vsp += gravity_down;

if (vsp < 0 && !input_jump_hold)
    vsp *= 0.5;


//-------------------------------------------------
// ATAQUE
//-------------------------------------------------

if (input_attack && !isAttacking) {
    isAttacking = true;
    sprite_index = PlayerGlitchCombo;
    image_index = 0;
}

if (isAttacking) {
    image_speed = 1;

    // Ventana activa de golpe (frames 3 a 5 por ejemplo)
    if (image_index >= 3 && image_index <= 5) {

        var sk = instance_place(x + lengthdir_x(20, image_xscale > 0 ? 0 : 180), y, Skeleton);

        if (sk && !sk.isHit) {
		    sk.isHit = true;
		    sk.hp -= 1;
		}
    }

    if (image_index >= image_number - 1) {
        isAttacking = false;
    }
}

//-------------------------------------------------
// MOVIMIENTO HORIZONTAL SIMPLE (SIN ACELERACIÓN)
//-------------------------------------------------

if (!isAttacking)
{
    var currentMaxSpeed = input_run ? maxSpeed * 1.5 : maxSpeed;
    hsp = move * currentMaxSpeed;
}
else
{
    hsp = 0;
}


//-------------------------------------------------
// MOVIMIENTO HORIZONTAL CON COLISIONES
//-------------------------------------------------

hsp_frac += hsp;
var hsp_int = round(hsp_frac);
hsp_frac -= hsp_int;

var hsp_abs = abs(hsp_int);
var hsp_sign = sign(hsp_int);

if (hsp_abs > 0)
{
    repeat (hsp_abs)
    {
        if (!place_meeting(x + hsp_sign, y, obj_solid))
        {
            x += hsp_sign;
        }
        else
        {
            hsp = 0;
            hsp_frac = 0;
            break;
        }
    }
}


//-------------------------------------------------
// MOVIMIENTO VERTICAL CON COLISIONES
//-------------------------------------------------

vsp_frac += vsp;
var vsp_int = round(vsp_frac);
vsp_frac -= vsp_int;

var vsp_abs = abs(vsp_int);
var vsp_sign = sign(vsp_int);

if (vsp_abs > 0)
{
    repeat (vsp_abs)
    {
        if (!place_meeting(x, y + vsp_sign, obj_solid))
        {
            y += vsp_sign;
        }
        else
        {
            vsp = 0;
            vsp_frac = 0;
            break;
        }
    }
}

//-------------------------------------------------
// SISTEMA DE RANGO LIMITE DEL MAPA
//-------------------------------------------------

x = clamp(x, 0, room_width);

if (y < 0) 
{
    y = 0;
    vsp = 0;
}

if (y > room_height + 64) 
{
    room_restart(); 
}

//-------------------------------------------------
// DIRECCIÓN SPRITE
//-------------------------------------------------

if (move != 0)
    image_xscale = sign(move) * base_scale;


//-------------------------------------------------
// SISTEMA DE CÁMARA (INTACTO)
//-------------------------------------------------

var input_detectado = (input_right || input_left || input_jump_pressed || input_attack);

if (input_detectado)
    ya_se_movio = true;

var target_w = ya_se_movio ? cam_ancho_juego : cam_ancho_inicio;
var target_h = ya_se_movio ? cam_alto_juego : cam_alto_inicio;

var target_x = ya_se_movio ? x : mouse_x;
var target_y = ya_se_movio ? y : mouse_y;

var cam = view_camera[0];
var cur_w = camera_get_view_width(cam);
var cur_h = camera_get_view_height(cam);
var cur_x = camera_get_view_x(cam);
var cur_y = camera_get_view_y(cam);

var new_w = lerp(cur_w, target_w, zoom_velocidad);
var new_h = lerp(cur_h, target_h, zoom_velocidad);
camera_set_view_size(cam, new_w, new_h);

var cam_target_x = target_x - (new_w / 2);
var cam_target_y = target_y - (new_h / 2);

cam_target_x = clamp(cam_target_x, 0, room_width - new_w);
cam_target_y = clamp(cam_target_y, 0, room_height - new_h);

var cam_vel = ya_se_movio ? 0.1 : 0.05;

var new_cam_x = lerp(cur_x, cam_target_x, cam_vel);
var new_cam_y = lerp(cur_y, cam_target_y, cam_vel);

camera_set_view_pos(cam, new_cam_x, new_cam_y);


//-------------------------------------------------
// ANIMACIONES
//-------------------------------------------------

if (!isAttacking)
{
    if (!onGround)
    {
        if (vsp < 0)
        {
            if (sprite_index != PlayerGlitchJump)
            {
                sprite_index = PlayerGlitchJump;
                image_index = 0;
            }
        }
        else
        {
            if (sprite_index != PlayerGlitchFall)
            {
                sprite_index = PlayerGlitchFall;
                image_index = 0;
            }
        }
    }
    else
    {
        if (abs(hsp) > 0)
        {
            if (input_run)
            {
                if (sprite_index != PlayerGlitchRun)
                {
                    sprite_index = PlayerGlitchRun;
                    image_index = 0;
                }
            }
            else
            {
                if (sprite_index != PlayerGlitchWalk)
                {
                    sprite_index = PlayerGlitchWalk;
                    image_index = 0;
                }
            }
        }
        else
        {
            if (sprite_index != PlayerGlitchIdle)
            {
                sprite_index = PlayerGlitchIdle;
                image_index = 0;
            }
        }
    }

    image_speed = 1;
}