function CreateRoom()
    local room = {
        RoomStartEvent = function (self)

        end,

        layers = {
            layer_01 = {
                depthRange = {0, 100},
                Instances = {}
            },

            layer_02 = {
                depthRange = {101, 200},
                Instances = {}
            },

            layer_03 = {
                depthRange = {201, 300},
                Instances = {}
            },

            layer_04 = {
                depthRange = {301, 400},
                Instances = {}
            },

            layer_05 = {
                depthRange = {401, 500},
                Instances = {}
            }
        }
    }

    return room
end

function goto_room(_room)

    CurrentRoom = _room

    _room:RoomStartEvent()

end
function room_restart()

    if CurrentRoom == nil then
        return
    end

    for i = 1, 5 do
        CurrentRoom.layers["layer_0" .. i].Instances = {}
    end

    CurrentRoom:RoomStartEvent()

end
