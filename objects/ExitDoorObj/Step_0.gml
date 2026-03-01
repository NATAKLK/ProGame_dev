// 1. ACTUALIZAR EL SPRITE SEGÚN LAS LLAVES (COFRES)
if (global.cofres_abiertos == 0) 
{
    sprite_index = Level_1_ExitDoor;
} 
else if (global.cofres_abiertos == 1) 
{
    sprite_index = Level_1_ExitDoor_1;
} 
else if (global.cofres_abiertos == 2) 
{
    sprite_index = Level_1_ExitDoor_2;
} 
else if (global.cofres_abiertos >= 3) 
{
    sprite_index = Level_1_ExitDoor_3;
}

// 2. INTERACCIÓN PARA SALIR DEL NIVEL
var tecla_e = keyboard_check_pressed(ord("E"));
var jugador_cerca = distance_to_object(PlayerObj) <= 15;

// Si presionamos E, estamos cerca de la puerta, y tenemos las 3 llaves:
