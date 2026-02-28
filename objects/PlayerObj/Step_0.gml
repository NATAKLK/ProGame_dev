var Left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var Right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var Shift = keyboard_check(vk_shift);
var Jump  = keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W"));

MovementSpeed = Shift ? 5 : 3;

image_yscale = base_scale;

if (Left) {
    x -= MovementSpeed;
    image_xscale = -base_scale;
    
    if (sprite_index != PlayerRun) {
        sprite_index = PlayerRun;
        image_index = 0;
    }
}
else if (Right) {
    x += MovementSpeed;
    image_xscale = base_scale;
    
    if (sprite_index != PlayerRun) {
        sprite_index = PlayerRun;
        image_index = 0;
    }
}
else {
    if (sprite_index != PlayerIdle) {
        sprite_index = PlayerIdle;
        image_index = 0;
    }
}