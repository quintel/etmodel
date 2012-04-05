/**
 * LockableFunction
 * Sometimes we need to put the lock the execution of certain functions. 
 * LockableFunction can be used to lock a function on a key. If the lock is
 * removed it will execute this function.
 *
 * Example:
 *
 * This immediately executes the function:
 *  
 *   LockableFunction.deferActionIfLocked("update", function() {alert('hee!')})
 *   
 * 
 * This only executes the second function after 10 seconds:
 * 
 *   LockableFunction.setLock("update")
 *   LockableFunction.deferActionIfLocked("update", function() {alert('I am function A!')})
 *   setTimeOut(function() {
 *    LockableFunction.removeLock("update")
 *   }, 10000)
 *   LockableFunction.deferActionIfLocked("update", function() {alert('I am function B')})
 * 
 * @responsible: Jaap
 * 
 */
var LockableFunction = {
  
  /* 
   * This function defers the execution of 
   */
  deferExecutionIfLocked: function(key, fun, options) {
    if(!this.functions)
      this.functions = {};
    if(this.isLocked(key)) {
      // defer the execution
      this.functions[key] = fun;
    } else {
      // immediately execute
      fun.apply();
    }
  },
  
  /**
   * Sets a lock on a specific key.
   */
  setLock:function(key) {
    if(!this.locks)
      this.locks = [];
    if(this.locks.indexOf(key) == -1)
      this.locks.push(key);
  },
  
  /**
   * Checks if this key is locked
   */
  isLocked:function(key) {
    if(!this.locks)
      return false;
    return this.locks.indexOf(key) != -1;
  },
  
  /**
   * Remove this lock.
   */
  removeLock:function(key) {
    if(this.isLocked(key)) {
      if(this.functions && this.functions[key])
        this.functions[key].apply();
      this.locks.splice(this.locks.indexOf(key), 1);
    }
  }
  
}