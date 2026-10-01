--index.lua
include("src/Import.lua")

function _init()
    goto_room(Platform_room)
end


function _update()

    local room = CurrentRoom
    if room ~= nil then
        for i = 1, 5 do
            local layer = room.layers["layer_0" .. i]
            for ins in all(layer.Instances) do
                ins:StepEvent0()
                ins:StepEvent()
            end
            for j = #layer.Instances, 1, -1 do
                if layer.Instances[j].destroy then
                    table.remove(layer.Instances, j)
                end
            end

        end
        
    end
    if game_gui~=nil then
        game_gui:update_all()
    end
end


function _draw()

    cls(1)

    local room = CurrentRoom

    if room ~= nil then

        -- Layer 按顺序处理
        for i = 1, 5 do

            local layer = room.layers["layer_0" .. i]

            local depth_list = {}
            local instance_list = {}
            local used = {}

            -- 收集 Instance
            for ins in all(layer.Instances) do

                if ins.use_depth then

                    -- 需要 depth 排序
                    add(instance_list, ins)
                    add(depth_list, ins.depth)

                else

                    -- 不需要 depth 排序
                    ins:DrawEvent0()
                    ins:DrawEvent()

                end

            end

            -- 对需要排序的 Instance 进行 depth 排序
            if #depth_list > 1 then
                QuickSort(depth_list, 1, #depth_list)
            end

            -- 按排序后的 depth 找回 Instance
            for j = 1, #depth_list do

                local depth = depth_list[j]

                for k = 1, #instance_list do

                    if used[k] ~= true
                    and instance_list[k].depth == depth then

                        instance_list[k]:DrawEvent0()
                        instance_list[k]:DrawEvent()

                        used[k] = true

                        break

                    end

                end

            end

        end

        -- Debug 碰撞框
        if draw_debug then
            for i = 1, 5 do
                local layer = room.layers["layer_0" .. i]
                for ins in all(layer.Instances) do
                    pset(ins.x, ins.y, 12)
                    if ins.mask ~= nil then
                        local left =ins.x + ins.mask.offset_x - ins.mask.w / 2
                        local top =ins.y + ins.mask.offset_y - ins.mask.h / 2
                        local right =ins.x + ins.mask.offset_x + ins.mask.w / 2
                        local bottom =ins.y + ins.mask.offset_y + ins.mask.h / 2
                        rect(left,top,right,bottom,12)
                    end
                end
            end
        end
        if game_gui~=nil then
            game_gui:draw_all()
        end
    end
end