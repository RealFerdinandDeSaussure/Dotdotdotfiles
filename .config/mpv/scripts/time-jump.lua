math.randomseed(os.time())

local function prev_or_start()
    if tonumber(mp.get_property("time-pos")) <= 2 then
        mp.command("playlist-prev")
    else
        mp.set_property("time-pos", 0)
    end
end

local function jump_to_random()
    local duration = tonumber(mp.get_property("duration"))
    local min = tonumber(mp.get_property("time-pos")) + 1
    local max = duration - (duration * 0.04)

    if min > max then
        return
    end

    max = ((max-min) / 2)
    max = min + max

    mp.set_property("time-pos", math.random(min, max))
end

mp.add_key_binding(nil, "prev-or-start", prev_or_start)
mp.add_key_binding(nil, "jump-to-random", jump_to_random)
