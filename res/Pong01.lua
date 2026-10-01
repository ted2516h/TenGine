--Pong01.lua

--YourAssets
tex_TenGine = fetch("TenGine.gfx")
tex_pong = fetch("Pong.gfx")
sfx_sound = fetch("music.sfx")
--/YourAssets


palt(0, false)
palt(30, true)

draw_debug = false


-- Sprite

spr_pat1 = CreateSprite(tex_pong, 1, 1, { 64, 64 })
spr_pat2 = CreateSprite(tex_pong, 2, 2, { 64, 64 })
spr_ball = CreateSprite(tex_pong, 3, 3, { 64, 64 })
spr_boom = CreateSprite(tex_pong, 9, 13, nil,-20,0)
--obj_pat
obj_pat= CreateObject(spr_pat1,{w = 1,h=64,offset_x = 0,offset_y= 0})
obj_pat.CreateEvent = function (self)
  self.old_x = self.x
  self.old_y = self.y
  self.is_moving = false

  self.spd = 1
  self.playerid = 0
  self.score = 0
end
obj_pat.StepEvent = function (self)
    if self.playerid==0 then
    if key("w") then
      self.y-=self.spd
    end
    if(key("s")) then
      self.y+=self.spd
    end
  end
  if self.playerid ==1 then

    if btn(2) then
      self.y-=self.spd
    end
    if btn(3) then
      self.y+=self.spd
    end

  end
  if self.y+self.spd<0+32 then
    self.y =32
  end
  if self.y+self.spd>270-32 then
    self.y =270-32
  end
  if self.spd>=5 then
    self.spd=5
  end
  self.is_moving =
      self.x ~= self.old_x
      or self.y ~= self.old_y

  -- 保存位置
  self.old_x = self.x
  self.old_y = self.y

end
obj_pat.set_playerid = function (self,_id)

    self.playerid = _id
    if _id == 0 then
      self.sprite_index = spr_pat1
    end
    if _id == 1 then
      self.sprite_index = spr_pat2
    end

end

obj_pat.DrawEvent = function (self)
  local draw_x_pos = 0
  if self.playerid == 0 then
    draw_x_pos = 0+100
  end
  if self.playerid == 1 then
    draw_x_pos = 480-100
  end
  print(flr(self.score),draw_x_pos,100)
  draw_self(self)
end
--/obj_pat


--obj_ball

obj_ball = CreateObject(spr_ball,{w = 7,h = 7,offset_x = 0,offset_y = 0})
obj_ball.CreateEvent = function (self)
  self.vx =1
  self.vy = 1
  self.spd = 1
end

obj_ball.StepEvent = function (self)
  if place_meeting(self,self.x,self.y,{obj_pat}).is_meeting then
    self.spd+=0.3
    place_meeting(self,self.x,self.y,{obj_pat}).meet_target.score+=1
    place_meeting(self,self.x,self.y,{obj_pat}).meet_target.spd+=0.2
    play_sfx(sfx_sound,0)
    self.vx= -self.vx
  end
  if self.y<=0 or self.y>=270 then
    self.vy = -self.vy
  end
  if self.x<0 or self.x>480 then

    
    if self.x<=0 then
      pat2.score += 20*self.spd
      Instance_create(obj_boom,self.x+10,self.y,Pong01_room)
    end
    if self.x>=480 then
      pat1.score += 20*self.spd
      Instance_create(obj_boom,self.x-10,self.y,Pong01_room)
    end
    self.x = 480/2 self.y = 270/2
    self.vx = -self.vx
    self.spd = 1
    play_sfx(sfx_sound,1)

  end
  self.x += self.vx*self.spd
  self.y += self.vy*self.spd

  if self.spd>=8 then
    self.spd = 8
  end
end
obj_ball.DrawEvent = function (self)
  draw_self(self)
end

--/obj_ball


--particle
particle = CreateObject()
particle.CreateEvent = function (self)
  self.owner = nil
end

particle.StepEvent = function (self)
  if self.owner ~=nil then
    self.x = self.owner.x
    self.y = self.owner.y
    
  end
  
end

particle.DrawEvent = function (self)
  if 1 then
    if self.owner == pat1 then
      draw_particle(self.x, self.y, "circle", 1, {8,9,10}, self.owner.spd*10, 2, 0,self.owner.spd/15)
    end
    if self.owner == pat2 then
      draw_particle(self.x, self.y, "circle", 1, {11,12,18}, self.owner.spd*10, 2, 0,self.owner.spd/15)
    end
    if self.owner == ball then
      draw_particle(self.x, self.y, "circle", 1, {8,24,2,10}, self.owner.spd*10, 3, 1,self.owner.spd/10)
    end
  end

  
end
--/particle

--obj_boom
obj_boom = CreateObject(spr_boom,nil)
obj_boom.DrawEvent = function (self)
  draw_self(self)
  
end
obj_boom.StepEvent = function (self)
  if self.x<480/2 then
    self.image_xscale = false
  end
  if self.x>480/2 then
    self.image_xscale = true
  end
  if self.image_index==self.sprite_index.finalFrame then
    Instance_destroy(self)
  end
end
--/obj_boom

--obj_manager
obj_manager = CreateObject()
obj_manager.StepEvent = function (self)
  if btnp(5) then
    room_restart()
  end
end
obj_manager.DrawEvent = function (self)
  print("press W or S \nto move player1 ",0+70,135,7)
  print("press Up or Down \nto move player2 ",480-130,135,7)
  print("press x to restart ",240-40,135,7)
end
--/obj_manager


Pong01_room = CreateRoom()
Pong01_room.RoomStartEvent = function (self)
  play_pattern(sfx_sound, 1)
  pat1 = Instance_create(obj_pat,0+10,100,Pong01_room,"layer_03")
  pat2 = Instance_create(obj_pat,480-10,100,Pong01_room,"layer_03")
  ball = Instance_create(obj_ball,480/2,270/2,Pong01_room,"layer_03")
  manager = Instance_create(obj_manager,480/2,270/2,Pong01_room,"layer_01")

  particle1 = Instance_create(particle,0,0,Pong01_room,"layer_02")
  particle2 = Instance_create(particle,0,0,Pong01_room,"layer_02")
  particle3 = Instance_create(particle,0,0,Pong01_room,"layer_02")
  pat1:set_playerid(0)
  pat2:set_playerid(1)

  particle1.owner = pat1
  particle2.owner = pat2
  particle3.owner = ball
end
