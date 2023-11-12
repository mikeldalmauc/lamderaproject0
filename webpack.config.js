const path = require('path');

module.exports = {
    mode: 'development',
    entry: './js/audio.js', // Ruta al archivo de entrada de tu aplicación
    output: {
        path: path.resolve(__dirname, 'elm-pkg-js'), // El directorio de destino para los archivos construidos
        filename: 'audioPort.js', // El nombre del archivo de salida
    },
    
};
