
--platform_game.lua

platform_tex = fetch("platform.gfx")
platform_sfx = fetch("music.sfx")
map01_config = include("res/platform01_map.lua")
palt(0, false)
palt(30, true)
draw_debug = false

--spr
spr_player_idle = CreateSprite(
    platform_tex,
    0,
    38,
    {128,128},
    0,
    0
)
spr_player_run = CreateSprite(
    platform_tex,
    64,
    102,
    {128,128},
    0,
    0
)
spr_player_jump = CreateSprite(
    platform_tex,
    128,
    144,
    {128,128},
    0,
    0
)
--/spr

--obj
obj_player = CreateObject(
    spr_player_idle,
    {
        w = 15,
        h = 15,
        offset_x = 0,
        offset_y = -8
    },false
)
obj_player.changeToState = function (self,_state)
    if self.state ~= _state then
        self.state = _state
        if self.state == "idle" then
            self.image_speed=3
            self.sprite_index = spr_player_idle
        elseif self.state == "run" then
            self.image_speed=2
            self.sprite_index = spr_player_run
        elseif self.state == "jump" then
            self.image_speed=1
            self.sprite_index = spr_player_jump
        end
        self.image_index = self.sprite_index.oriFrame
    end
end

obj_player.CreateEvent = function (self)
    self.vx = 0
    self.vy = 0
    self.spd = 1
    self.flipX = false
    self.isfloor = false
    self.t = 0
    self.state = "idle"
    self.score = 0
end
obj_player.StepEvent = function (self)
    camera(self.x-480/2,30)
    self.vx = 0
    -- jump
    if self.isfloor == true then
        if keyp("w") then self.vy = -10 end 
        end
    -- move
    if key("a") then
        self.vx = -1
        self.flipX = true
    end
    if key("d") then
        self.vx = 1
        self.flipX = false
    end
    self.image_xscale = self.flipX
    -- gravity
    self.vy += 0.7

    local collision = move_and_slide(
        self,
        self.vx,
        self.vy,
        obj_wall
    )

    self.isfloor = collision.hit_y and self.vy == 0

    
    -- self.x+=self.vx
    -- self.y+=self.vy
    -- state
    if self.vx ~= 0 and self.isfloor == true then
        self.changeToState(self,"run"
        )
    elseif self.vx == 0 and self.isfloor == true then
        self.changeToState(self,"idle")

    elseif self.isfloor ~= true then
        self.changeToState(self,"jump")
    end
end

obj_player.DrawEvent = function (self)
    draw_self(self)
    end


-- wall

obj_wall = CreateObject(
    CreateSprite(
        platform_tex,
        192,
        192,
        {16,16},
        0,
        0
    ),
    {
        w = 16,
        h = 16,
        offset_x = 8,
        offset_y = 8
    },false
)


obj_coin = CreateObject(CreateSprite(platform_tex,200,204,{16,16},0,0),{w=16,h=16,offset_x=0,offset_y=0},false)
obj_coin.CreateEvent = function (self)
    self.image_speed = 0.3
end
obj_coin.StepEvent = function (self)
    local collision = place_meeting(self,self.x,self.y,obj_player)
    if collision.is_meeting then
        collision.meet_target.score+=1
        play_sfx(platform_sfx,0)
        Instance_destroy(self)
    end
end
obj_coin.DrawEvent = function (self)
    draw_self(self)
    --print(111,self.x,self.y)
end


obj_tiledmap =CreateObject()
    
obj_tiledmap.DrawEvent = function (self)
    for row, data in ipairs(platform01_map.map_data) do

        for column, index in ipairs(data) do

            if index ~=0 then
                spr(platform_tex[index+191].bmp,column*16,row*16)
            end

        end

    end
end
--/obj

--room

Platform_room = CreateRoom()
--/room
Platform_room.RoomStartEvent = function(self)

    self.object_instances = {}
    Create_TiledMap_collision(platform01_map,obj_wall,Platform_room)
    Create_TiledMap_object(platform01_map,{[11]=obj_coin},Platform_room)



    ins_player = Instance_create(obj_player,100,100,Platform_room)
    ins_tiledmap = Instance_create(obj_tiledmap,0,0,Platform_room)
    game_gui = create_gui()
    local button = game_gui:attach_button({
        x = 20,
        y = 20,
        width = 33,
        height = 18
    })
    local button1 = game_gui:attach_button({
        x = 20,
        y = 40,
        width = 53,
        height=18,
        label = "collide"
    })


    function button:update(msg)
        self.label = tostring("Coin:"..ins_player.score)
    end
    function button1:tap(msg)
        draw_debug = not draw_debug
    end
end
