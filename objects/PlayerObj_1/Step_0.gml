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


if keyboard_check(vk_escape) {
	game_end()
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
    attackBuffer--;

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