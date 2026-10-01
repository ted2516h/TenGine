-- Object.lua

function CreateObject(_sprite_index, _mask, _use_depth)

    local object = {

        sprite_index = _sprite_index or nil,

        mask = _mask or {
            w = 32,
            h = 32,
            offset_x = 0,
            offset_y = 0
        },

        -- 是否参与 depth 排序
        use_depth = _use_depth ~= false,

        image_speed = 1,
        image_xscale = false,
        image_yscale = false,

        -- Create Event 0
        CreateEvent0 = function(self)

            if self.sprite_index ~= nil then
                self.image_index = self.sprite_index.oriFrame
            end

        end,


        -- Create Event
        CreateEvent = function(self)

        end,


        -- Step Event 0
        StepEvent0 = function(self)

            if self.sprite_index ~= nil then

                self.image_index += self.image_speed

                if flr(self.image_index) > self.sprite_index.finalFrame then
                    self.image_index = self.sprite_index.oriFrame
                end

            end

            if self.use_depth then
                self.depth = self.y
            end

        end,


        -- Step Event
        StepEvent = function(self)

        end,


        -- Draw Event 0
        DrawEvent0 = function(self)

        end,


        -- Draw Event
        DrawEvent = function(self)

        end,


        -- GameMaker draw_self()
        draw_self = function(self)

            if self.sprite_index ~= nil then

                spr(
                    self.sprite_index.tex[flr(self.image_index)].bmp,
                    self.x - self.sprite_index.frameSize[1] / 2,
                    self.y - self.sprite_index.frameSize[2] / 2
                )

            end

        end
    }

    return object

end



function Instance_create(_obj, _x, _y, _room, _layer)

    local room = _room
    local layer = _layer or "layer_01"

    if room == nil then
        return nil
    end

    local currentLayer = room.layers[layer]

    local instance = {

        x = _x,
        y = _y,

        destroy = false,

        depth = 0,

        image_index = 0,
        image_speed = _obj.image_speed,

        sprite_index = _obj.sprite_index,
        mask = _obj.mask,

        object = _obj,

        room = room,
        layer = layer
    }

    setmetatable(instance, {
        __index = _obj
    })

    -- 加入 Layer
    add(currentLayer.Instances, instance)

    -- 加入 Object 索引
    if room.object_instances[_obj] == nil then
        room.object_instances[_obj] = {}
    end

    add(room.object_instances[_obj], instance)

    instance:CreateEvent0()
    instance:CreateEvent()

    return instance

end

function Instance_destroy(self)

    if self == nil then
        return
    end

    self.destroy = true

end