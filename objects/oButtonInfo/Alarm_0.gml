 // Inherit the parent event
event_inherited();

if (instance_exists(oControls))
{
	instance_destroy(oControls);
}

else 
{
	instance_create_layer(x + 8 , y + 30, "Instances", oControls); 
}