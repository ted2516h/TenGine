--GameTest.lua
Obj1 = CreateObject(nil,{w = 10,h = 10,offset_x = 0,offset_y = 0})
Obj1.StepEvent = function (self)
end

Spr1 = CreateSprite(tex_TenGine,1,1,{128,128})
Spr2 = CreateSprite(tex_TenGine,2,6,{64,64})

Obj1.sprite_index = Spr1

Obj2 = CreateObject()
Obj2.StepEvent = function (self)
    local vx = 0
    local vy = 0
    if key("a") then
        vx=-1
    end
    if key("d") then
        vx=1
    end
    if key("w") then
        vy = -1
    end
    if key("s") then
        vy = 1
    end
    Move_and_slide(self,vx,vy,{Obj1})
end
Obj2.DrawEvent = function (self)
    print(self.image_index,self.x,self.y)
end
Obj2.sprite_index = Spr2
Obj2.CreateEvent = function (self)
    self.image_speed=0.2
end
Room2 = CreateRoom()
Instance_create(Obj1,100,10,Room2,"layer_01")
Instance_create(Obj2,200,30,Room2,"layer_01")


