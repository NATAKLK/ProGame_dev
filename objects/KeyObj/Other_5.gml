if (activa) 
{
    vueltas += 1; // Sumamos una vuelta terminada

    if (vueltas >= 3) 
    {
        // Si ya dio 3 vueltas, la desactivamos
        activa = false;
        image_speed = 0;
        image_index = 0; // Vuelve al frame 0 (invisible)
    } 
    else 
    {
        // Si no ha llegado a 3 vueltas, sigue girando.
        // Forzamos a que vuelva al frame 1 para esquivar el frame 0 invisible
        image_index = 1; 
    }
}