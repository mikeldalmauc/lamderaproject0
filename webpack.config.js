const path = require('path');

module.exports = {
    mode: 'development',
    entry: './js/my_app.js', // Ruta al archivo de entrada de tu aplicación
    output: {
        path: path.resolve(__dirname, 'public'), // El directorio de destino para los archivos construidos
        filename: 'bundle.js', // El nombre del archivo de salida
    },
    
};
