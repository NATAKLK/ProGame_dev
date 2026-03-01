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

// 1. Detectar si ya nos movimos
var input_detectado = (input_right || input_left || input_jump_pressed || input_attack);

if (input_detectado) {
    ya_se_movio = true;
}

// --- MEJORA: Excepción para un Room específico ---
// Cambia "rm_menu" por el nombre real de tu room donde NO quieres zoom
var es_room_sin_zoom = (room == rm_menu); 

// Si ya se movió O si estamos en el room sin zoom, usamos el tamaño de juego
var target_w = (ya_se_movio || es_room_sin_zoom) ? cam_ancho_juego : cam_ancho_inicio;
var target_h = (ya_se_movio || es_room_sin_zoom) ? cam_alto_juego : cam_alto_inicio;

// El objetivo a seguir (personaje o ratón)
var target_x = ya_se_movio ? x : mouse_x;
var target_y = ya_se_movio ? y : mouse_y;

var cam = view_camera[0];
var cur_w = camera_get_view_width(cam);
var cur_h = camera_get_view_height(cam);
var cur_x = camera_get_view_x(cam);
var cur_y = camera_get_view_y(cam);

// 2. Aplicar el Zoom suave
var new_w = lerp(cur_w, target_w, zoom_velocidad);
var new_h = lerp(cur_h, target_h, zoom_velocidad);
camera_set_view_size(cam, new_w, new_h);

// 3. Calcular hacia dónde debe ir la cámara (centrada)
var cam_target_x = target_x - (new_w / 2);
var cam_target_y = target_y - (new_h / 2);

var cam_vel = ya_se_movio ? 0.1 : 0.05;

// 4. Mover la cámara suavemente
var new_cam_x = lerp(cur_x, cam_target_x, cam_vel);
var new_cam_y = lerp(cur_y, cam_target_y, cam_vel);

// --- MEJORA: Clampear al FINAL ---
// Esto garantiza 100% que la cámara JAMÁS muestre un borde negro en este frame
new_cam_x = clamp(new_cam_x, 0, room_width - new_w);
new_cam_y = clamp(new_cam_y, 0, room_height - new_h);

// 5. Aplicar la posición final
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