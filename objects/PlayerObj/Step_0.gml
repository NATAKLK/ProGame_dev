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

if (onGround)
{
    coyoteTimer = coyoteTimeMax;
}
else
{
    coyoteTimer--;
}

if (input_jump_pressed)
{
    jumpBuffer = jumpBufferMax;
}
else
{
    jumpBuffer--;
}

if (jumpBuffer > 0 && coyoteTimer > 0)
{
    vsp = jump_force;
    jumpBuffer = 0;
    coyoteTimer = 0;
}

if (vsp < 0)
    vsp += gravity_up;
else
    vsp += gravity_down;

if (vsp < 0 && !input_jump_hold)
{
    vsp *= 0.5;
}

if (input_attack)
{
    if (!isAttacking)
    {
        isAttacking = true;
        comboStep = 1;
        sprite_index = PlayerGlitchCombo;
        image_index = 0;
    }
    else
    {
        attackBuffer = attackBufferMax;
    }
}

if (attackBuffer > 0)
{
    attackBuffer--;
}

if (isAttacking)
{
    image_speed = 1;

    if (image_index >= image_number - 1)
    {
        if (comboStep == 1 && attackBuffer > 0)
        {
            comboStep = 2;
            sprite_index = PlayerGlitchComboEnd;
            image_index = 0;
            attackBuffer = 0;
        }
        else
        {
            isAttacking = false;
            comboStep = 0;
        }
    }
}

var accel = onGround ? accel_ground : accel_air;

if (!isAttacking)
{
    if (move != 0)
    {
        hsp += move * accel;
    }
    else
    {
        if (hsp > 0)
            hsp = max(0, hsp - friction);
        else if (hsp < 0)
            hsp = min(0, hsp + friction);
    }
}
else
{
    hsp = 0;
}

var currentMaxSpeed = input_run ? maxSpeed * 1.5 : maxSpeed;
hsp = clamp(hsp, -currentMaxSpeed, currentMaxSpeed);

hsp_frac += hsp;
var hsp_int = round(hsp_frac);
hsp_frac -= hsp_int;

var hsp_abs = abs(hsp_int);
var hsp_sign = sign(hsp_int);

if (hsp_abs > 0) {
    repeat (hsp_abs) {
        if (place_meeting(x + hsp_sign, y, obj_solid)) {
            var ty = 1;
            while (ty <= 12) { 
                if (!place_meeting(x + hsp_sign, y - ty, obj_solid)) {
                    y -= ty;
                    break;
                }
                ty++;
            }
        }
        
        if (!place_meeting(x + hsp_sign, y, obj_solid) && !place_meeting(x, y + 1, obj_solid) && place_meeting(x + hsp_sign, y + 13, obj_solid)) {
            var dy = 1;
            while (!place_meeting(x + hsp_sign, y + dy, obj_solid) && dy <= 12) {
                dy++;
            }
            y += dy - 1;
        }

        if (!place_meeting(x + hsp_sign, y, obj_solid)) {
            x += hsp_sign;
        } else {
            hsp = 0;
            hsp_frac = 0; 
            break;
        }
    }
}

vsp_frac += vsp;
var vsp_int = round(vsp_frac);
vsp_frac -= vsp_int;

var vsp_abs = abs(vsp_int);
var vsp_sign = sign(vsp_int);

if (vsp_abs > 0) {
    repeat (vsp_abs)
    {
        if (!place_meeting(x, y + vsp_sign, obj_solid))
        {
            y += vsp_sign;
        }
        else
        {
            if (vsp < 0) 
            {
                if (!place_meeting(x + 1, y + vsp_sign, obj_solid)) { x += 1; continue; }
                if (!place_meeting(x - 1, y + vsp_sign, obj_solid)) { x -= 1; continue; }
            }
            
            vsp = 0;
            vsp_frac = 0; 
            break;
        }
    }
}

if (move != 0)
{
    image_xscale = sign(move) * base_scale;
}

var input_detectado = (input_right || input_left || input_jump_pressed || input_attack);

if (input_detectado) ya_se_movio = true;

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

        image_speed = 1;
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

        image_speed = 1;
    }
}