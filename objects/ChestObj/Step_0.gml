// Detectamos si el jugador presionó la tecla "E"
var tecla_e = keyboard_check_pressed(ord("E"));

// Comprobamos si el jugador (PlaterObj) está a 15 píxeles o menos de distancia
var jugador_cerca = distance_to_object(PlayerObj) <= 15;

// Si presionamos E, estamos cerca, y el cofre NO está abierto:
if (tecla_e && jugador_cerca && !abierto)
{
    // 1. Marcamos el cofre como abierto para no volver a activarlo
    abierto = true;
    
    // 2. Cambiamos el sprite y reproducimos la animación desde el frame 0
    sprite_index = ChestOpen; 
    image_index = 0;          
    image_speed = 1;          
    
    // 3. Le sumamos 1 al contador global de cofres abiertos
    global.cofres_abiertos += 1;
    
    // 4. Verificamos si ya llegamos a los 3 cofres
    if (global.cofres_abiertos >= 3)
    {
        // Pasamos al siguiente nivel (o pones tu código de victoria aquí)
        room_goto_next(); 
    }
}