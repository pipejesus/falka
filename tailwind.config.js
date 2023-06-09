/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./**/*.{js,ts,jsx,tsx}",
  ],
  theme: {    
    extend: {
      screens: {
        '2xl': '1410px',
        '3xl': '1536px',
        '4xl': '1920px'
      },
      gridTemplateRows: {        
        '12': 'repeat(12, minmax(0, 1fr))',      
      },
      gridRow: {
        'span-7': 'span 7 / span 7',
        'span-8': 'span 8 / span 8',
        'span-9': 'span 9 / span 9',
        'span-10': 'span 10 / span 10',
        'span-11': 'span 11 / span 11',
        'span-12': 'span 12 / span 12',
      },
      gridRowStart: {
        '7': '7',
        '8': '8',
        '9': '9',
        '10': '10',
        '11': '11',
        '12': '12',        
      },
      gridRowEnd: {
        '7': '7',
        '8': '8',
        '9': '9',
        '10': '10',
        '11': '11',
        '12': '12',        
      },
      dropShadow: {
        'ptack': '20px 22px 0px #efefef'
      }
    }
  },
  daisyUI: {
    themes: ["corporate"],
    darkTheme: ["corporate"]
  },
  plugins: [
    require("@tailwindcss/typography"), require("daisyui"),
  ],  
}

