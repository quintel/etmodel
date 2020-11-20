/**
 * Takes a function and memoized the value after the first call.
 *
 * memoize returns a function which will call the given "func" and memoize the results. Memoized
 * values may be cleared with `clear`, which will cause the func to be called again the next time
 * the memoized value is evaluated.
 *
 * @example
 *    memoize(() => somethingExpensive(true))
 *
 * @example Clear the result
 *    const remember = memoize(() => somethingExpensive(true))
 *    remember()       // computes and memoizes value
 *    remember()       // returns memoized value
 *    remember.clear() // clears memozied value
 *    remember()       // computes and memoizes value
 */
export default func => {
  let value = null;

  let callable = () => {
    if (!value) {
      value = func();
    }

    return value;
  };

  callable.clear = () => (value = null);

  return callable;
};
