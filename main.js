import './style.css';
import 'instagram.css/dist/instagram.css';
import 'shader-doodle';
import ClipboardJS from 'clipboard';
import shaderString from './circlz.shader.glsl?raw';
import falkaShaderString from './fallusie.shader.glsl?raw';
import initModule from './index.js';
import Alpine from 'alpinejs';

window.resizeRaylibCanvas = null;
window.Alpine = Alpine;
Alpine.start();

const elements = {
    canvasPtack: null,
    canvasPtackGrid: null,
};

function scanElements() {
    elements.canvasPtack = document.querySelector('#canvas');
    elements.canvasPtackGrid = document.querySelector('[data-canvas-ptack-grid]');    
}

function getCanvasPtackSize() {
    return {
        width: elements.canvasPtack.offsetWidth,
        height: elements.canvasPtack.offsetHeight
    };
}

window.onload = () => {
    scanElements();

    // const vids = document.getElementsByTagName('video');
    // Array.from(vids).forEach(el => { el.onended = function () {
    //     this.load();
    //     this.play();
    //   }});

    // new ClipboardJS('[data-clipboard-copy]', {

    // });

    const shaderContainer = document.getElementById('circlz_shader_container');
    const falkaShaderContainer = document.getElementById('falka_shader_container');
    
    const doodle = document.createElement('shader-doodle');
    doodle.setAttribute('shadertoy', '');
    doodle.classList.add('w-full', 'h-auto', 'aspect-square', 'lg:aspect-video', 'lg:w-1/2');
    
    const doodleShader = document.createElement('script');
    doodleShader.setAttribute('type', 'x-shader/x-fragment');
    doodleShader.textContent = shaderString;
    doodle.appendChild(doodleShader);
    shaderContainer.appendChild(doodle);

    const falkaDoodle = document.createElement('shader-doodle');
    falkaDoodle.setAttribute('shadertoy', '');
    falkaDoodle.classList.add('w-full', 'h-full');
    
    const falkaDoodleShader = document.createElement('script');
    falkaDoodleShader.setAttribute('type', 'x-shader/x-fragment');
    falkaDoodleShader.textContent = falkaShaderString;
    falkaDoodle.appendChild(falkaDoodleShader);
    falkaShaderContainer.appendChild(falkaDoodle);    

    initModule({
        print: function (n) {    
            arguments.length > 1 && (n = Array.prototype.slice.call(arguments).join(" ")), console.log(n)
        }, 
        canvas: elements.canvasPtack 
    }).then((raylibModule) => {        
        window.resizeRaylibCanvas = raylibModule.cwrap(
            "onResize",
            null,
            ["number", "number"]
        );
        
        resizeHandler();
    });

    let resizeHandler = () => {        
        const dimensions = getCanvasPtackSize();

        const w = elements.canvasPtack.width
            = dimensions.width;

        const h = elements.canvasPtack.height
            = dimensions.height;                

        window?.resizeRaylibCanvas(w, h);
    }

    window.addEventListener(
        "resize",
        resizeHandler,
        true
    );
};

