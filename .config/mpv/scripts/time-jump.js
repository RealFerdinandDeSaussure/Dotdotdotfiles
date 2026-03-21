function prevOrStart () {
    if (mp.get_property('time-pos') <= 2) {
        mp.command('playlist-prev')
    } else {
        mp.set_property('time-pos', 0)
    }
}

function jumpToRandom () {
    var duration = mp.get_property('duration')
    var min = parseInt(mp.get_property('time-pos')) + 1
    var max = duration - (duration * 0.04)
    if (min > max ) {
        return
    }

    max = ((max - min) / 2)
    max = min + max

    mp.set_property('time-pos', getRandomInt(min, max))
}

function getRandomInt (min, max) {
    return Math.floor(Math.random() * (max - min)) + parseInt(min)
}

mp.add_key_binding(null, 'jump-to-start', prevOrStart)
mp.add_key_binding(null, 'jump-to-random', jumpToRandom)
