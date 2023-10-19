const delay = (ms, now) =>
  new Promise((resolve, rej) =>
    setTimeout(() => {
      // rej("papa")
      resolve(!(now === undefined) ? now : Date.now());
    }, ms)
  );

console.log("Start");

delay(1000).then((res) => console.log(res));

console.log("End!");

const waitFor = (promise, ms) => {
  return new Promise((res, rej) => {
    delay(ms).then(() => {
      rej(`Timeout after ${ms}ms`);
    });
    promise.then((onResolve, onReject) => {
      if (onReject) {
        rej(onReject);
      }
      res(onResolve);
    });
  });
};

waitFor(delay(200), 300);
