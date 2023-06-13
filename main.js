import './style.css';
import 'instagram.css/dist/instagram.css';
import 'shader-doodle';
import shaderString from './circlz.shader.glsl?raw';
import falkaShaderString from './fallusie.shader.glsl?raw';
import initModule from './index.js';
import Alpine from 'alpinejs';
import dataBody from './src/body-data-alpine.js';

window.resizeRaylibCanvas = null;
window.Alpine = Alpine;
Alpine.data('dataBody', dataBody);
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

function attachShaderToContainer(containerId, classList, shaderContents) {    
    const shaderContainer = document.getElementById(containerId);
    const doodle = document.createElement('shader-doodle');
    doodle.setAttribute('shadertoy', '');
    doodle.classList.add(...classList);
    
    const doodleShader = document.createElement('script');
    doodleShader.setAttribute('type', 'x-shader/x-fragment');
    doodleShader.textContent = shaderContents;
    doodle.appendChild(doodleShader);
    shaderContainer.appendChild(doodle);    
}

let resizeHandler = () => {        
    const dimensions = getCanvasPtackSize();
    const w = elements.canvasPtack.width = dimensions.width;
    const h = elements.canvasPtack.height = dimensions.height;                
    window?.resizeRaylibCanvas(w, h);
}

function removePreloader() {
    const b = document.querySelector('body');
    b.classList.add('loaded');
}

function attachPtackAnimation() {
    initModule({
        print: function (n) {    
            // arguments.length > 1 && (n = Array.prototype.slice.call(arguments).join(" ")), console.log(n)
        }, 
        canvas: elements.canvasPtack 
    }).then((raylibModule) => {        
        window.resizeRaylibCanvas = raylibModule.cwrap(
            "onResize",
            null,
            ["number", "number"]
        );        
        
        resizeHandler();
        removePreloader();
    }).catch((rejected)=>{
        removePreloader();
    });

    window.addEventListener(
        "resize",
        resizeHandler,
        true
    );    
}

document.addEventListener("DOMContentLoaded", () => {
    scanElements();
    attachShaderToContainer('circlz_shader_container', ['w-full', 'h-auto', 'aspect-square', 'lg:aspect-video', 'lg:w-1/2'], shaderString);
    attachShaderToContainer('falka_shader_container', ['w-full', 'h-full'], falkaShaderString);
});

window.onload = () => {
    attachPtackAnimation();
};

