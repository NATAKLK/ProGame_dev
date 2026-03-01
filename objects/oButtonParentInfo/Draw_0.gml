               
draw_self(); 


draw_set_font(Fnt_MenuSmaller);
draw_set_halign(fa_center); 
draw_set_valign(fa_middle); 


var texto_y = y; 

if (sprite_index == sMenuBottonP) 
{
 
    texto_y += 4; 
}
else if (sprite_index == sMenuBottonH)
{
	
	texto_y -=4;
}
else
{
	texto_y = y
}

draw_set_color(c_dkgray); 
draw_text(x, texto_y, button_text);


draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);