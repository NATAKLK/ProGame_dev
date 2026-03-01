if (sprite_index == ChestOpen)
{
    // 1. Congelar el cofre abierto
    image_speed = 0; 
    image_index = image_number - 1; 
    
    // 2. Buscar la llave que esté colocada junto a este cofre y activarla
    var mi_llave = instance_nearest(x, y, KeyObj);
    
    // Si encontró una llave, le damos las instrucciones mágicas con "with"
    if (mi_llave != noone) 
    {
        with (mi_llave) 
        {
            activa = true;   // Le decimos que ya puede empezar a contar
            image_speed = 1; // Le damos play a la animación
            image_index = 1; // Saltamos el frame 0 al instante
            vueltas = 0;     // Reiniciamos el contador por si acaso
        }
    }
}