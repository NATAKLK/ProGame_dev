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


// COYOTE TIME

if (onGround)
{
    coyoteTimer = coyoteTimeMax;
}
else
{
    coyoteTimer--;
}


// JUMP BUFFER

if (input_jump_pressed)
{
    jumpBuffer = jumpBufferMax;
}
else
{
    jumpBuffer--;
}


// SALTO

if (jumpBuffer > 0 && coyoteTimer > 0)
{
    vsp = jump_force;
    jumpBuffer = 0;
    coyoteTimer = 0;
}


// GRAVEDAD DINÁMICA

if (vsp < 0)
    vsp += gravity_up;
else
    vsp += gravity_down;


// SALTO VARIABLE

if (vsp < 0 && !input_jump_hold)
{
    vsp *= 0.5;
}


// SISTEMA DE ATAQUE

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


// VELOCIDAD MÁXIMA
var currentMaxSpeed = input_run ? maxSpeed * 1.5 : maxSpeed;
hsp = clamp(hsp, -currentMaxSpeed, currentMaxSpeed);


// COLISIÓN HORIZONTAL

var hsp_abs = abs(hsp);
var hsp_sign = sign(hsp);

repeat (hsp_abs)
{
    if (!place_meeting(x + hsp_sign, y, obj_solid))
    {
        x += hsp_sign;
    }
    else
    {
        hsp = 0;
        break;
    }
}


// COLISIÓN VERTICAL

var vsp_abs = abs(vsp);
var vsp_sign = sign(vsp);

repeat (vsp_abs)
{
    if (!place_meeting(x, y + vsp_sign, obj_solid))
    {
        y += vsp_sign;
    }
    else
    {
        vsp = 0;
        break;
    }
}


// VOLTEAR SPRITE

if (move != 0)
{
    image_xscale = sign(move) * base_scale;
}


// ANIMACIONES

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