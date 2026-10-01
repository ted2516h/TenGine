--Global.lua
Global = {
    defaultText = "Hello World!!!"
}

function Partition(A, low, high)
    local pivot = A[low]
    while low < high do
        while low < high and A[high] >= pivot do
            high = high - 1
        end
        A[low] = A[high]
        while low < high and A[low] <= pivot do
            low = low + 1
        end
        A[high] = A[low]
    end
    A[low] = pivot
    return low
end

function QuickSort(A,low,high)
    if low<high then
        local pivotpos = Partition(A,low,high)
        QuickSort(A,low,pivotpos-1)
        QuickSort(A,pivotpos+1,high)
    end
end


function move_and_slide(self, _vx, _vy, _obj) 
    local vx = _vx
    local vy = _vy

    local hit_x = false
    local hit_y = false

    -- X
    if vx ~= 0 then
        if place_meeting(self, self.x + vx, self.y, _obj).is_meeting then
            vx = 0
            hit_x = true
        end
    end

    -- Y
    if vy ~= 0 then
        if place_meeting(self, self.x, self.y + vy, _obj).is_meeting then
            vy = 0
            hit_y = true
        end
    end

    self.x += vx
    self.y += vy

    self.vx = vx
    self.vy = vy

    return {
        hit_x = hit_x,
        hit_y = hit_y
    }
end
function place_meeting(self, _x, _y, _obj)

    local room = self.room

    if room == nil then
        return {
            is_meeting = false,
            meet_target = nil
        }
    end

    -- 直接取得这个 Object 的实例列表
    local instances = room.object_instances[_obj]

    if instances == nil then
        return {
            is_meeting = false,
            meet_target = nil
        }
    end

    -- 只遍历目标 Object 的实例
    for ins in all(instances) do

        if ins ~= self
        and ins.mask ~= nil then

            if AABB(
                _x,
                _y,
                self.mask.offset_x,
                self.mask.offset_y,
                self.mask.w / 2,
                self.mask.h / 2,

                ins.x,
                ins.y,
                ins.mask.offset_x,
                ins.mask.offset_y,
                ins.mask.w / 2,
                ins.mask.h / 2
            ) then

                return {
                    is_meeting = true,
                    meet_target = ins
                }

            end

        end

    end

    return {
        is_meeting = false,
        meet_target = nil
    }

end

function play_sfx(_sfx, _index)
    _sfx:poke(0x30000)
    sfx(_index)
end

function play_pattern(_sfx, _index)
    _sfx:poke(0x30000)
    music(_index, nil, nil, 0x30000)
end


function collide_with(self, _obj)

    local room = self.room

    if room == nil then
        return nil
    end
    for i = 1, 5 do
        local layer = room.layers["layer_0" .. i]
        for ins in all(layer.Instances) do

            if ins ~= self
            and ins.object == _obj
            and ins.mask ~= nil then
                if
                (AABB(self.x,self.y,self.mask.offset_x,self.mask.offset_y,self.mask.w/2,self.mask.h/2,
                    ins.x,ins.y,ins.mask.offset_x,ins.mask.offset_y,ins.mask.w/2,ins.mask.h/2))
                then return ins

                end

            end

        end

    end

    return nil

end

function AABB(
    Ax, Ay, AoffsetX, AoffsetY, Aw, Ah,
    Bx, By, BoffsetX, BoffsetY, Bw, Bh
)

    local A_left   = Ax + AoffsetX - Aw
    local A_right  = Ax + AoffsetX + Aw
    local A_top    = Ay + AoffsetY - Ah
    local A_bottom = Ay + AoffsetY + Ah

    local B_left   = Bx + BoffsetX - Bw
    local B_right  = Bx + BoffsetX + Bw
    local B_top    = By + BoffsetY - Bh
    local B_bottom = By + BoffsetY + Bh

    if A_right > B_left
    and A_left < B_right
    and A_bottom > B_top
    and A_top < B_bottom then

        return true

    else

        return false

    end
end