function draw_particle(
    _x,
    _y,
    _shape,
    _num,
    _colors_list,
    _life,
    _ori_radious,
    _final_radious,
    _force
)

    if particles == nil then
        particles = {}
    end

    -- 创建粒子
    for i = 1, _num do

        local angle = rnd(1)
        local speed = _force * (0.5 + rnd(0.5))

        add(particles, {
            x = _x,
            y = _y,

            vx = cos(angle) * speed,
            vy = sin(angle) * speed,

            -- 生命周期
            life = _life,

            -- 大小
            radius = _ori_radious,
            ori_radious = _ori_radious,
            final_radious = _final_radious,

            color = _colors_list[
                flr(rnd(#_colors_list)) + 1
            ],

            shape = _shape,

            -- 拖尾历史位置
            trail = {},

            -- 拖尾长度
            trail_length = 5
        })
    end

    -- 更新 + 绘制
    for i = #particles, 1, -1 do

        local p = particles[i]

        -- 保存上一帧的位置
        add(p.trail, {
            x = p.x,
            y = p.y
        })

        if #p.trail > p.trail_length then
            table.remove(p.trail, 1)
        end

        -- 移动
        p.x += p.vx
        p.y += p.vy

        -- 速度衰减
        p.vx *= 0.92
        p.vy *= 0.92

        -- 生命周期
        p.life -= 1

        -- 生命周期比例
        local t = 1 - p.life / _life

        -- 根据生命周期改变大小
        p.radius =
            p.ori_radious +
            (p.final_radious - p.ori_radious) * t

        -- 绘制拖尾
        for j = 1, #p.trail do

            local trail = p.trail[j]

            local trail_t = j / #p.trail

            local trail_radius =
                p.radius * trail_t

            if p.shape == "circle" then

                circfill(
                    trail.x,
                    trail.y,
                    trail_radius,
                    p.color
                )

            elseif p.shape == "rect" then

                rectfill(
                    trail.x - trail_radius,
                    trail.y - trail_radius,
                    trail.x + trail_radius,
                    trail.y + trail_radius,
                    p.color
                )

            end
        end

        -- 绘制粒子本体
        if p.shape == "circle" then

            circfill(
                p.x,
                p.y,
                p.radius,
                p.color
            )

        elseif p.shape == "rect" then

            rectfill(
                p.x - p.radius,
                p.y - p.radius,
                p.x + p.radius,
                p.y + p.radius,
                p.color
            )

        end

        -- 生命周期结束
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end
end