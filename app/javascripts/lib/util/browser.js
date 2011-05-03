var Browser = {
  doesTouch:function() {
       try {
           // if we can make touch events return true
           document.createEvent("TouchEvent");
           return true;
       } catch(e) { 

           return false;
       }
   },
   
   makeSureArrayHasFunctionIndexOf:function() {
     if (!Array.indexOf) {
       Array.prototype.indexOf = function (obj, start) {
         for (var i = (start || 0); i < this.length; i++) {
           if (this[i] == obj) {
             return i;
           }
         }
         return -1;
       }
     }
   }
  
}



Browser.makeSureArrayHasFunctionIndexOf();