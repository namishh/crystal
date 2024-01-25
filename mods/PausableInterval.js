export const pausableInterval = (interval, callback) => {
  let source;
  return {
    stop() {
      if (source) {
        source.destroy();
        source = null;
      } else {
        console.warn('already stopped')
      }
    },
    start() {
      if (!source) {
        source = setInterval(callback, interval);
      } else {
        console.warn('already running')
      }
    },
    toggle() {
      if (!source) {
        source = setInterval(callback, interval);
      } else {
        source.destroy();
        source = null;
      }
    },
  }
}


