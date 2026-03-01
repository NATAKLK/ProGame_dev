if (activa) 
{
    // Si GameMaker intentó reiniciar la animación volviendo al frame 0 (o menos de 1)
    if (image_index < 1) 
    {
        image_index = 1; // Lo empujamos de golpe al frame 1 ANTES de que se dibuje
        vueltas += 1;    // Contamos que acaba de dar una vuelta
        
        // Si ya completó sus 2 vueltas
        if (vueltas >= 2) 
        {
            activa = false;  // Apagamos la llave
            image_speed = 0; // Detenemos la animación
            image_index = 0; // La volvemos a poner en el frame 0 (invisible)
        }
    }
}