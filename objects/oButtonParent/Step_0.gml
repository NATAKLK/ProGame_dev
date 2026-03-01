if (cliqueado == false) 
{

    if (position_meeting(mouse_x, mouse_y, id)) 
    {
       
        if (mouse_check_button_pressed(mb_left)) 
        {
            cliqueado = true; 
            
          
            sprite_index = sMenuBottonP; 
            
           
            alarm[0] = 15; 
        } 
        else 
        {
          
            sprite_index = sMenuBottonH; 
        }
    } 
    else 
    {
        
        sprite_index = sMenuBottonN; 
    }
}