import * as v3d from 'verge3d';

const appjs = new v3d.App('v3d-container');

appjs.loadScene('cube.glb', () => {
    appjs.enableControls();
    appjs.run();
});


