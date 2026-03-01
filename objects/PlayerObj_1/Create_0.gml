// MOVIMIENTO
hsp = 0;
vsp = 0;
hsp_frac = 0;
vsp_frac = 0;

maxSpeed = 1.5;

gravity_up = 0.1;
gravity_down = 0.1;
jump_force = -3;

// TOLERANCIAS
coyoteTimeMax = 6;
coyoteTimer = 0;

jumpBufferMax = 6;
jumpBuffer = 0;

// ESCALA
base_scale = 1;
image_yscale = base_scale;
image_xscale = base_scale;

// ATAQUE
isAttacking = false;
comboStep = 0;
attackBuffer = 0;
attackBufferMax = 10;

// CÁMARA
var display_w = display_get_width();
var display_h = display_get_height();
var proporcion = display_w / display_h;

cam_alto_inicio = 480;
cam_ancho_inicio = 480 * proporcion;

cam_alto_juego = 240;
cam_ancho_juego = 240 * proporcion;

zoom_velocidad = 0.02;
ya_se_movio = false;

view_enabled = true;
view_visible[0] = true;

view_wport[0] = display_w;
view_hport[0] = display_h;

surface_resize(application_surface, display_w, display_h);
window_set_size(display_w, display_h);
window_set_fullscreen(true);