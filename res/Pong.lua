--Pong.lua

--YourAssets
tex_TenGine = fetch("TenGine.gfx")
tex_pong = fetch("Pong.gfx")
sfx_sound = fetch("music.sfx")
--/YourAssets





Global.spd = 2

palt(0, false)
palt(30, true)

draw_debug = true


-- Sprite

spr_pat1 = CreateSprite(tex_pong, 1, 1, { 64, 64 })
spr_pat2 = CreateSprite(tex_pong, 2, 2, { 64, 64 })
spr_ball = CreateSprite(tex_pong, 3, 3, { 64, 64 })
spr_boom = CreateSprite(tex_pong, 9, 13, nil)


-- Object

obj_pat1 = CreateObject(
    spr_pat1,
    {
        w = 10,
        h = 64,
        offset_x = 0,
        offset_y = 0
    }
)

obj_pat2 = CreateObject(
    spr_pat2,
    {
        w = 10,
        h = 64,
        offset_x = 0,
        offset_y = 0
    }
)

obj_ball = CreateObject(
    spr_ball,
    {
        w = 10,
        h = 10,
        offset_x = 0,
        offset_y = 0
    }
)

obj_score = CreateObject()

obj_boom = CreateObject(spr_boom, nil)


-- Boom

obj_boom.StepEvent = function(self)
    if self.image_index == 4 then

    end
end


-- Player 1

obj_pat1.CreateEvent = function(self)
    self.spd = 1
end


obj_pat1.StepEvent = function(self)
    if self.spd >= 5 then
        self.spd = 5
    end

    if key("w") then
        self.y -= Global.spd
    end

    if key("s") then
        self.y += Global.spd
    end
end


-- Player 2

obj_pat2.CreateEvent = function(self)
    self.spd = 1
end


obj_pat2.StepEvent = function(self)
    if self.spd >= 5 then
        self.spd = 5
    end

    if btn(2) then
        self.y -= self.spd
    end

    if btn(3) then
        self.y += self.spd
    end
end


-- Ball

obj_ball.CreateEvent = function(self)
    self.vx = 2
    self.vy = 3
    self.spd = 1
end


obj_ball.StepEvent = function(self)
    self.x += self.vx * self.spd
    self.y += self.vy * self.spd


    -- 上下反弹

    if self.y <= 0 or self.y >= 270 then
        self.vy = -self.vy
    end


    -- 碰撞

    local collision = place_meeting(
        self,
        self.x,
        self.y,
        {
            pat1,
            pat2
        }
    )

    if collision.is_meeting then
        self.vx = -self.vx

        play_sfx(sfx_sound, 0)

        self.spd += 0.5

        pat1.spd += 0.3
        pat2.spd += 0.3
    end


    -- 左边得分

    if self.x < 0 then
        score.score2 += 1

        self.x = 480 / 2
        self.y = 270 / 2

        self.vx = -self.vx

        play_sfx(sfx_sound, 1)

        self.spd = 1
    end


    -- 右边得分

    if self.x > 480 then
        score.score1 += 1

        self.x = 480 / 2
        self.y = 270 / 2

        self.vx = -self.vx

        play_sfx(sfx_sound, 1)

        self.spd = 1
    end
end


-- Score

obj_score.CreateEvent = function(self)
    self.score1 = 0
    self.score2 = 0
end


obj_score.DrawEvent0 = function(self)

end


obj_score.DrawEvent = function(self)
    print(self.score1, 0 + 100, 100)
    print(self.score2, 480 - 100, 100)
end


-- Room

Room_pong = CreateRoom()


-- Instance

pat1 = Instance_create(
    obj_pat1,
    10,
    100,
    Room_pong
)

pat2 = Instance_create(
    obj_pat2,
    470,
    100,
    Room_pong
)

ball = Instance_create(
    obj_ball,
    240,
    100,
    Room_pong
)

score = Instance_create(
    obj_score,
    0,
    0,
    Room_pong
)



