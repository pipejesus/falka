export default () => ({
    current: null,      
    navItems: [],
    observer: null,
    isNavigating: false,
    timeOut: null,      
    ptackModal: false,
    stackPhaze: 0,      
    music: false,  
    sectionToVideos: {},    

    init() {
        const sections = document.querySelectorAll('section');

        this.navItems = Array.from(sections).map(item => {          
          return {
            slug: item.dataset.sectionSlug,
            name: item.dataset.sectionName,
            element: item
          }
        });
  
        this.navItems.forEach((item) => {
          const vids = Array.from(item.element.querySelectorAll('video'));        
          this.sectionToVideos[item.slug] = vids;                
        });      
  
        this.current = this.navItems[0].slug;      
  
        addEventListener('scroll', (e) => {                  
          clearTimeout(this.timeOut);
          this.timeOut = setTimeout(() => {
              this.isNavigating = false;            
          }, 200);
        });      
  
        this.$watch('current', value => {

          if (window.hasOwnProperty('deactivatePtack') && window.hasOwnProperty('activatePtack')) {
            if (value !== 'animation') {            
              window.deactivatePtack();
            } else {
              window.activatePtack();
            }  
          }

          Object.entries(this.sectionToVideos).forEach(item => {
            const [sectionName, sectionVideos] = item;
            
            if (! sectionVideos.length) {
              return;
            }
  
            sectionVideos.forEach(video => { 
              video.pause(); 
            });
          });
  
          if (! this.sectionToVideos[value].length) {
            return;
          }
  
          this.sectionToVideos[value].forEach(video => {          
            video.play();
          });
        });
        
        this.observer = new IntersectionObserver(
          (entries) => {
            for(const entry of entries) {
              if(entry.isIntersecting) {
                if (! this.isNavigating) {
                  const entrySlug = entry.target.dataset.sectionSlug;
                  this.current = entrySlug;
                }
              }
            }              
          },
          {
            rootMargin: '-50% 0px'
          }
        );
        
        for (const element of sections) {
          this.observer.observe(element);
        } 
    },

    navClick(slug) {
      this.isNavigating = true; 
      const search = `[data-section-slug=${slug}]`;
      const screen = document.querySelector(search);
      screen?.scrollIntoView({
        behavior: 'auto',
        block: 'start',
      });
      this.current = slug;
    }      
})