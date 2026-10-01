--tiledmap.lua

function Create_TiledMap_collision(_map_config,_obj_collision,_target_room,_tile_sizeX,_tiled_sizeY)
    local tile_sizeX =_tile_sizeX or 16
    local tile_sizeY =_tile_sizeY or 16
    for row, data in ipairs(_map_config.collision_data) do

        for column, index in ipairs(data) do

            if index ~= 0 then
                local ins = Instance_create(
                    _obj_collision,
                    column * tile_sizeX,
                    row * tile_sizeY,
                    _target_room
                )
            end

        end

    end
end

function Create_TiledMap_object(_map_config, _obj_map, _target_room,_tile_sizeX,_tiled_sizeY)
    local tile_sizeX =_tile_sizeX or 16
    local tile_sizeY =_tile_sizeY or 16
    local map_config = _map_config

    if map_config == nil then
        return
    end

    for row, data in ipairs(map_config.obj_data) do

        for column, index in ipairs(data) do

            if index ~= 0 then

                local obj = _obj_map[index]

                if obj ~= nil then

                    Instance_create(
                        obj,
                        column * tile_sizeX,
                        row * tile_sizeY,
                        _target_room
                    )

                end

            end

        end

    end

end

function Draw_TiledMap(_gfx,_map_config,offset_index,_tile_sizeX,_tiled_sizeY)
    local tile_sizeX =_tile_sizeX or 16
    local tile_sizeY =_tile_sizeY or 16
    for row, data in ipairs(_map_config.map_data) do

        for column, index in ipairs(data) do

            if index ~=0 then
                spr(_gfx[index+offset_index].bmp,column*tile_sizeX,row*tile_sizeY)
            end

        end

    end
end