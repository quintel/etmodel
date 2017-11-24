Array.prototype.chunk = function (size) {
    return this.reduce(function (res, item, index) {
        if (index % Math.ceil(this.length / size) === 0) { res.push([]); }
        res[res.length-1].push(item);
        return res;
    }.bind(this), []);
}
