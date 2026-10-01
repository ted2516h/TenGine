--Sprite.lua
function CreateSprite(_tex,_oriFrame,_finalFrame,_frameSize,_offset_x,_offset_y)
    local sprite_index = {
        offset_x = _offset_x or 0,
        offset_y = _offset_y or 0,
        frameSize = _frameSize or {64,64},
        tex = _tex,
        oriFrame = _oriFrame,
        finalFrame = _finalFrame,
        
    }
    return sprite_index
end
function draw_self(self)

    if self.sprite_index ~= nil then
        local flipX = self.image_xscale
        local offsetX
        local offsetY
        if flipX == false then
            offsetX = self.sprite_index.offset_x
            offsetY = self.sprite_index.offset_y
        end
        if flipX == true then
            offsetX = -self.sprite_index.offset_x
            offsetY = -self.sprite_index.offset_y
        end
        spr(
            self.sprite_index.tex[flr(self.image_index)].bmp,
            self.x - self.sprite_index.frameSize[1] / 2-offsetX,
            self.y - self.sprite_index.frameSize[2] / 2-offsetY,
            self.image_xscale,self.image_yscale
        )

    end

end