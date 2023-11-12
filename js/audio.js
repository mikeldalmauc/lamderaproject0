import VirtualAudioContext from './elm-web-audio.js'

exports.init = async function(app) {
    const ctx = new AudioContext()
    const virtualCtx = new VirtualAudioContext(ctx)


    app.ports.toWebAudio.subscribe((nodes) => {
        virtualCtx.update(nodes)
    })
}


